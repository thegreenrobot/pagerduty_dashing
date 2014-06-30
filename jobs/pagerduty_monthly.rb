require 'faraday'
require 'json'
require 'chronic'

data_file = './lib/secrets.json'
parsed_data = JSON.parse( IO.read( data_file ))

url = parsed_data['url']
api_key = parsed_data['api_key']

month = Time.now.strftime("%m")
year = Time.now.strftime("%Y")

SCHEDULER.every '60s' do
  conn = Faraday.new(:url => "#{url}") do |faraday|
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
    faraday.headers['Content-type'] = 'application/json'
    faraday.headers['Authorization'] = "Token token=#{api_key}"
    faraday.params['since'] = Chronic.parse("#{month}/1/#{year} at midnight")
    faraday.params['until'] = Chronic.parse('now')
    faraday.params['status'] = 'resolved'
  end

  response = conn.get '/api/v1/incidents/count/'
  
  if response.status == 200
    response_result = JSON.parse(response.body)
    monthly_incidents = response_result['total']
  else
    monthly_incidents = 0
  end

  send_event('monthly_incidents', { value: monthly_incidents})

end
