require 'rack/lobster'
require 'net/http'
require 'json'

map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/' do
  served_by = proc do |env|
    uri = URI('http://backend.fd.svc.cluster.local:8080/me')
    res = Net::HTTP.get_response(uri)
    case res
    when Net::HTTPSuccess then
      data = JSON.parse(res.body)
      [ 200, { "Content-Type" => "text/html" }, [ "Served by #{data["Hostname"]}\n" ]]
    else
      [ res.code, { "Content-Type" => "text/html" }, res.message ]
    end
  end
end
