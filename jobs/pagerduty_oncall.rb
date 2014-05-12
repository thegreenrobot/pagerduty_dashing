require 'faraday'
require 'json'
require 'pp'
# make sure your secrets.json has an "escalation_policy":"blahblah" entry

data_file = './lib/secrets.json'
parsed_data = JSON.parse( IO.read( data_file ))

url = parsed_data['url']
api_key = parsed_data['api_key']

# empty array of oncalls
oncall = {}

# for each ep....
parsed_data['escalation_policies'].each do |key, value|
  oncall[key] = value
end

SCHEDULER.every '5s' do
  oncall.each do |key,value|
    conn = Faraday.new(:url => "#{url}") do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Authorization'] = "Token token=#{api_key}"
   end

  response = conn.get "/api/v1/escalation_policies/#{value}/on_call"
  pp(response)
  if response.status == 200
    oncall_result = JSON.parse(response.body)
    #Note: this is currently broken for group alerting. Need to make it just look for the first entry where level:1, then where level:2
    user_name = oncall_result['escalation_policy']['on_call'][0]['user']['name']
  else
    user_name = 'John Doe'
  end

  send_event("#{key}-name", { text: user_name})
  end



end
