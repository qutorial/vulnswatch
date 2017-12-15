require 'rubygems'
require 'json'
require 'net/http'
require 'logger'
require 'uri'
require 'date'


module Couch

    class TimeoutException < RuntimeError
        def code
            0
        end
        
        def body
            ""
        end
    end

    @@logger = Logger.new(STDOUT)

    def self.address 
        config = Rails.configuration.couch
        return { port: config["port"], host: config["host"], db: config["database"], 
                 protocol: config["protocol"] }
    end


    def  self.couch_user
        return Rails.configuration.couch["user"]
    end

    def  self.couch_password
        return Rails.configuration.couch["password"]
    end
    
    def self.couch_uri
        return URI::HTTP.build(scheme: address[:protocol], 
        userinfo:"#{couch_user}:#{couch_password}", host: address[:host], 
        port: address[:port])
    end

    def self.couch_address
        couch_uri.to_s
    end
    

    def self.uuid
        uri = URI(couch_address + '/_uuids')
        response = Net::HTTP.get(uri)
        res = JSON.parse(response)
        uuid = res["uuids"].first
        return uuid
    end



    def self.do_request(req, timeout = 5)
        port = address[:port]
        host = address[:host]
        req.basic_auth couch_user, couch_password
        http = Net::HTTP.new(host, port)
        http.read_timeout= timeout
        begin 
            res = http.start {|http| http.request(req) }
            return res
        rescue Net::ReadTimeout
            return TimeoutException.new
        end
    end

    def self.build_path(path)
        path = "/" + address[:db] + "/" + path
    end

    def self.db_path()
        return build_path('')
    end

    def self.put_json (path, body)
        path = build_path(path)
        req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json'})
        req.body = body
        response = do_request(req)
        return [response.code == "201", response]
    end

    def self.delete path
        path = build_path path
        req = Net::HTTP::Delete.new(path)
        response = do_request(req)
        return response
    end

    def self.get_json(path, absolute = false, timeout = 5)
        if ! absolute
            path = build_path(path)
        end
        req = Net::HTTP::Get.new(path, initheader = { 'Content-Type' => 'application/json'})
        response = do_request(req, timeout)
        if response.code == "200"
            res = JSON.parse(response.body)
            return [true, res, response]
        else
            return [false, nil, response]
        end
    end

    def self.delete_database(force = false)
        #@@logger.info "Deleting Couch DB"
        if ! force && ! address[:db] == "cves_test"
            return [false, "not forced, not deleting", nil]
        end

        req = Net::HTTP::Delete.new(db_path)
        response = do_request(req)
        return [response.code == "200", "Sent request", response]
    end

    def self.create_database()
        #@@logger.info "Creating Couch DB"
        path = db_path
        req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json'})
        response = do_request(req)
        return [response.code == "201", "Request sent", response]
    end

    # returns {success, message, busy?, [details] }
    def self.get_couchdb_status
        res = get_json '/_active_tasks', true, 2
        if !res[0]
            return {success: false, message: "Couchdb is not responding timely, please, wait", busy: nil, details: []}
        end

        busy = false
        message = "Ready for queries"
        details = []

        res[1].each do |process|
            if process["type"] == "indexer" 
                busy = true
                message = "Indexing in progress"
                details += [{started_on: Time.at(process["started_on"]), progress: process["progress"] }]
            end
        end

        

        res = {success: true, message: message, busy: busy, details: details}

        #@@logger.info "Couch DB status now: #{res} "

        return res
    end

    def self.get_vuln id
        path = id.to_s
        get_json path
    end

    def self.view_template
        template="function (doc) {
    var re = /$RE$/i;
    if(doc.tags) {
        if (doc.tags.length > 0){
            if(re.test(doc.tags.join())){
                emit(doc.id, 1);
            }
            // not matching on summary then
            return;
        }
    }
    if (re.test(doc.summary)) {
        emit(doc.id, 1);
    }
    
    }"
        return template
    end

    def self.view_for_systems systems
        res = view_template
        re = systems.collect{ |x| "\\b" + Regexp.escape(x) + "\\b" }.join("|")
        return res.sub("$RE$", re)
    end

    def self.delete_vulnerability vulnerability
        path = "#{vulnerability.id}"
        res = delete path
        return {success: res.code == "200", message: "Delete requested", response: res}
    end

    def self.put_vulnerability vulnerability
        path = "#{vulnerability.id}"
        res = get_json path
        if ! res[0]
            body = vulnerability.cve_to_json
            res = put_json path, body.to_json
            if res[0]
                return [true, "Created new vulnerability in couchdb", res[1]]
            else
                return [false, "Failed to create a new vulnerability in couchdb", res[1]]
            end
        else
            old_body = res[1]
            new_body  = old_body.merge vulnerability.cve_to_json
            if ! (old_body == new_body)
                res = put_json path, new_body.to_json
                if res[0]
                    return [true, "Update a vulnerability in couchdb", res[1]]
                else
                    return [false, "Failed to update a  vulnerability in couchdb", res[1]]
                end
            else
                return [true, "Vulnerability is up to date in couchdb", nil]
            end
        end
        
    end

    def self.design_doc_path view_name
        view_name = URI.escape(view_name)
        "_design/#{view_name}"
    end

    def self.views_path view_name
        view_name = URI.escape(view_name)
        design_doc_path(view_name) + "/_view"
    end

    def self.view_path view_name
        view_name = URI.escape(view_name)
        views_path(view_name) + "/#{view_name}"
    end
    
    def self.design_doc_template name 
        template="{
            \"_id\" : \"_design/example\",
            \"views\" : {
            }
          }"

          return template.gsub('example', URI.escape(name))
    end

    def self.put_view name, code

        name = URI.escape(name)

        path = design_doc_path name
        res = get_json(path)

        new_views = {
            "#{name}": {
                "map": code
            }}
        
        if ! res[0]
            json = {"_id": "_design/#{name}", "views": new_views}.to_json
            res = put_json design_doc_path(name), json
            if ! res[0]
                return [false, "Failed to create a design document #{name}", res[2]]
            else
                return [true, "Created a new design document #{name}", res[2]]
            end
        
        end
        
        body = res[1]
        views = body["views"]

        if views.nil?
            body["views"] = new_views
        else
            if views == new_views
                return [true, "No need to update the view", res[2]]
            else
                body["views"] = new_views
            end
        end

        #@@logger.debug "Creating view: #{body[0..100]}..."

        res = put_json path, body.to_json
        
        if ! res[0]
            return [false, "Error when putting a new view in the couchdb", res[1]]
        else
            return [true, "Updated the view successfully", res[1]]
        end
    end

    def self.view_name_for_project project
        "u#{project.user.id}p#{project.id}"
    end

    def self.view_name_for_user user
        "u#{user.id}"
    end

    def self.view_for_project project
        return [view_name_for_project(project), view_for_systems(project.systems)]
    end

    def self.view_for_user user
        return [view_name_for_user(user), view_for_systems(RelevantVulnerability.users_systems(user))]
    end

    def self.update_view_for_project_no_user project
        res = []
        view = view_for_project project
        res[0] = put_view view[0], view[1]

        #@@logger.debug "Updated a view for project##{project.id} #{project.name}: #{res}"

        return res
    end

    def self.update_view_for_user user
        res = []
        view = view_for_user user
        res[0] = put_view view[0], view[1]

        #@@logger.debug "Updated a view for user##{user.id}: #{res}"

        return res
    end

    def self.update_view_for_project project
        res = []

        res += update_view_for_project_no_user project
     
        res += update_view_for_user project.user
    
        return res
    end

    def self.update_all_views
        Project.all.each do |project|
            update_view_for_project_no_user project
        end
        User.all.each do |user|
            update_view_for_user user
        end
    end

    def self.update_vulnerabilities_in_couchdb
        res = [true, []]
        Vulnerability.all.each do |vulnerability|
            localres = Couch.put_vulnerability vulnerability
            if ! localres[0]
                res[0] = false
                res[1] += [localres[1], localres[2]]
                @@logger.debug "Could not update a vulnerability in couchdb #{vulnerability.name}"
                @@logger.debug "#{localres[1]}"
                @@logger.debug "#{localres[2]}"
            else
                @@logger.debug "Updated vulnerability in couchdb #{vulnerability.name}"
            end 
        end 
        return res
    end

    def self.get_relevant_vulnerabilities_for_user user
        #@@logger.debug "Getting vulnerabilities for user##{user.id} #{user.name} from couchdb"
        res = get_relevant_vulnerabilities view_name_for_user user
        #@@logger.debug "Got: #{res}"
        return res
    end

    def self.get_relevant_vulnerabilities_for_project project
        #@@logger.debug "Getting vulnerabilities for project##{project.id} \"#{project.name}\" from couchdb..."
        res = get_relevant_vulnerabilities view_name_for_project project
        #@@logger.debug "Got: #{res}"
        return res
    end

    def self.get_relevant_vulnerabilities view_name
        res = Couch.get_json(view_path view_name)
        if ! res[0]
            return [false, [], "Could not get vulnerabilities from couchdb", res[2]]
        end

        ids = res[1]["rows"].collect { |vuln| vuln["id"] }

        return [true, ids, "Returning successfully from couchdb", res[2]]
    end

end

#require_relative "lib/couch/couch"