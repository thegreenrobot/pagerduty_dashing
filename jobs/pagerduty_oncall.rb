require 'faraday'
require 'json'

data_file = './lib/secrets.json'
parsed_data = JSON.parse( IO.read( data_file ))

url = parsed_data['url']
api_key = parsed_data['api_key']

schedules = {}

parsed_data['schedules'].each do |key, value|
  schedules[key] = value
end

SCHEDULER.every '30s' do
  schedules.each do |key, value|
    conn = Faraday.new(:url => "#{url}") do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-type'] = 'application/json'
      faraday.headers['Authorization'] = "Token token=#{api_key}"
      faraday.params['since'] = Time.now.utc.iso8601()
      faraday.params['until'] = (Time.now.utc + 60).iso8601()
    end

  response = conn.get "/api/v1/schedules/#{value}"
  if response.status == 200
    schedule_result = JSON.parse(response.body)
    user_name = schedule_result['schedule']['schedule_layers'][0]['rendered_schedule_entries'][0]['user']['name']
  else
    user_name = 'John Doe'
  end

  send_event("#{key}-name", { text: user_name})

  end
end
