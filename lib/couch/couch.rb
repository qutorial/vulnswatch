require 'rubygems'
require 'json'
require 'net/http'


def uuid
  uri = URI('http://127.0.0.1:5984/_uuids')
  response = Net::HTTP.get(uri)
  res = JSON.parse(response)
  uuid = res["uuids"].first
  return uuid
end

def address 
    return { port: 5984, host: "127.0.0.1", db: "cves" }
end

def do_request(req)
    port = address[:port]
    host = address[:host]
    req.basic_auth ENV["COUCH_ADMIN"], ENV["COUCH_ADMIN_PASSWORD"]
    return Net::HTTP.new(host, port).start {|http| http.request(req) }
end

def build_path(path)
    path = "/" + address[:db] + "/" + path
end

def put_json (path, body)
    path = build_path(path)
    req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json'})
    req.body = body
    response = do_request(req)
    return [response.code == "201", response]
end

def get_json(path)
    path = build_path(path)
    req = Net::HTTP::Get.new(path, initheader = { 'Content-Type' => 'application/json'})
    response = do_request(req)
    if response.code == "200"
        res = JSON.parse(response.body)
        return [true, res, response]
    else
        return [false, nil, response]
    end
end

def save_vuln vuln
    path = "#{vuln.id}"
    response = put_json address path vuln.to_json
    puts response
end

def view_template
    template="function (doc) {
  var re = /$RE$/i;
  if (re.test(doc.summary)) {
    emit(doc.id, doc.summary)
  }
  
}"
    return template
end

def view_for_systems systems
    res = view_template
    re = systems.collect{ |x| "\\b" + Regexp.escape(x) + "\\b" }.join("|")
    return res.sub("$RE$", re)
end


def put_view name, code
    path = "_design/VulnsWatch"
    res = get_json(path)
    if ! res[0]
        return [false, "Error getting design doc from couchdb", res[2]]
    end
    body = res[1]
    view = body["views"][name]
    if ! view.nil?
        old_code = body["views"][name]["map"]
        if !old_code.nil? && old_code == code
            return [true, "No need to update the view", res[2]]
        end
    end

    body["views"][name] = {"map": code}
    
    res = put_json path, body.to_json
    
    if ! res[0]
        return [false, "Error when putting a new view in the couchdb", res[1]]
    else
        return [true, "Updated the view successfully", res[1]]
    end
end


#r = put_view "u1p1", view_code


