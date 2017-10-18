#!/usr/bin/ruby

require 'uri'
require 'net/http'
require 'bunny'

connection_details = {
  :host      => "ci-slave1.virtapi.org",
  :port      => 5672,
  :ssl       => false,
  :vhost     => "/",
  :user      => "guest",
  :pass      => "guest",
  :auth_mechanism => "PLAIN"
}

conn = Bunny.new(connection_details)
conn.start # establish connection to rabbitmq
ch = conn.create_channel
x = ch.fanout("marcelliitest")
q = ch.queue("", :auto_delete => true).bind(x)
q.subscribe do |delivery_info, properties, payload|
  puts "[consumer] #{q.name} received a message: #{payload}"
end
x.publish('this is a test')

#url = URI("https://api.twitter.com/1.1/search/tweets.json?q=%23BigData_Corp_Int")
#
#http = Net::HTTP.new(url.host, url.port)
#http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#
#request = Net::HTTP::Get.new(url)
#request["authorization"] = 'OAuth oauth_consumer_key=\"0g7NQj0ughknNxnzSqrlMteu0\",oauth_token=\"916030610216509440-NQe6ZfinZXLRvgCOPu5cWvs4x7ej6JA\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"1508353633\",oauth_nonce=\"AkfJu3\",oauth_version=\"1.0\",oauth_signature=\"d99lswktSowcjKJJw4bHhpVm3g4%3D\"'
#request["cache-control"] = 'no-cache'


#response = http.request(request)
#variable = response.read_body
