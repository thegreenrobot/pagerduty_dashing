require 'faraday'
require 'json'
require 'chronic'

data_file = './lib/secrets.json'
parsed_data = JSON.parse( IO.read( data_file ))

url = parsed_data['url']
api_key = parsed_data['api_key']

SCHEDULER.every '30s' do
  conn = Faraday.new(:url => "#{url}") do |faraday|
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
    faraday.headers['Content-type'] = 'application/json'
    faraday.headers['Authorization'] = "Token token=#{api_key}"
    faraday.params['since'] = Chronic.parse('last sunday at midnight')
    faraday.params['until'] = Chronic.parse('now')
    faraday.params['status'] = 'resolved'
  end

  response = conn.get '/api/v1/incidents/count/'
  
  if response.status == 200
    response_result = JSON.parse(response.body)
    weekly_incidents = response_result['total']
  else
    weekly_incidents = 0
  end

  send_event('weekly_incidents', { value: weekly_incidents})

end
