require 'faraday'
require 'json'
# make sure your secrets.json has an "escalation_policy":"blahblah" entry

data_file = './lib/secrets.json'
parsed_data = JSON.parse( IO.read( data_file ))

url = parsed_data['url']
api_key = parsed_data['api_key']
escalation_policy = parsed_data['escalation_policy']

oncalls = {}

SCHEDULER.every '5s' do
    conn = Faraday.new(:url => "#{url}") do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Authorization'] = "Token token=#{api_key}"
      faraday.params['since'] = Time.now.utc.iso8601()
      faraday.params['until'] = (Time.now.utc + 60).iso8601()
   end

  response = conn.get "/api/v1/escalation_policies/#{escalation_policy}/on_call"
  if response.status == 200
    oncall_result = JSON.parse(response.body)
    #Note: this is currently broken for group alerting. Need to make it just look for the first entry where level:1, then where level:2
    primary = oncall_result['escalation_policy']['on_call'][0]['user']['name']
    secondary = oncall_result['escalation_policy']['on_call'][1]['user']['name']
  else
    user_name = 'John Doe'
  end

  send_event("primary-name", { text: primary})
  send_event("backup-name", { text: secondary})

end

