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
    faraday.params['since'] = Chronic.parse('yesterday at midnight')
    faraday.params['until'] = Chronic.parse('today at midnight')
    faraday.params['rollup'] = 'daily'
  end

  response = conn.get '/api/v1/reports/incidents_per_time/'
  
  if response.status == 200
    response_result = JSON.parse(response.body)
    daily_incidents = response_result['incidents'][0]['number_of_incidents']
  else
    daily_incidents = 0
  end

  send_event('daily_incidents', { value: daily_incidents})

end
