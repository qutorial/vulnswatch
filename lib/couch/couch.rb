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

def put_json (path, body)
    port = address[:port]
    host = address[:host]
    path = "/" + address[:db] + "/" + path
    req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json'})
    req.body = body
    req.basic_auth 'admin', 'admin'
    return Net::HTTP.new(host, port).start {|http| http.request(req) }
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

def view_json (name, code)
    return {views: {
             "#{name}": {
                 "map": "#{code}"
                         }
             }
    }.to_json
end

def put_view name, code
    path = "_design/VulnsWatch"
    body = view_json name, code
    return put_json path, body
end

##

view_code = view_for_systems ["Apache", "MySQL"]

r = put_view "u1p1", view_code

###

TBD: Update the design doc properly
curl 'http://localhost:5984/cves/_design/VulnsWatch'{"_id":"_design/VulnsWatch","_rev":"7-7f7e5fd21bb29c6b0b313821b882f8c3","views":{"u1p1":{"map":"function (doc) {\n  var re = /\\bApache\\b|\\bMySQL\\b/i;\n  if (re.test(doc.summary)) {\n    emit(doc.id, doc.summary)\n  }\n  \n}"}}}

