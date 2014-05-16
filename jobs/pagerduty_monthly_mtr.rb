require 'faraday'
require 'json'
require 'chronic'

secrets_file = './lib/secrets.json'
secrets_data = JSON.parse( IO.read( secrets_file ))

@url = secrets_data['url']
@api_key = secrets_data['api_key']

@monthly_resolution_times = []
@monthly_total_incidents = 0

# Call the PagerDuty API and get the incidents
def monthly_pd_query(offset)
  month = Time.now.month
  year = Time.now.year
  conn = Faraday.new(:url => "#{@url}") do |faraday|
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
    faraday.headers['Content-type'] = 'application/json'
    faraday.headers['Authorization'] = "Token token=#{@api_key}"
    faraday.params['since'] = Chronic.parse("#{month}/1/#{year} at midnight")
    faraday.params['until'] = Chronic.parse('now')
    faraday.params['offset'] = offset
    faraday.params['limit'] = 50
    faraday.params['status'] = 'resolved'
  end

  response = conn.get '/api/v1/incidents/'

  if response.status == 200
    data = JSON.parse(response.body)
    @monthly_total_incidents = data['total']
  else
    data['total'] == 0
  end
  return data
end

# Caclulate the mtr (mean time to resolution) and format it
def calc_monthly_mtr()
  mtr = @monthly_resolution_times.inject{ |sum, el| sum + el }.to_f / @monthly_resolution_times.size
  mtr = (mtr / 60).round(3)
  return mtr
end

SCHEDULER.every '30s' do

  while @monthly_resolution_times.length <= @monthly_total_incidents do

    # We're just starting out, first query to PagerDuty
    if @monthly_resolution_times.length == 0
      offset = 0
    # We have all of the incidents, stop querying
    elsif @monthly_resolution_times.length == @monthly_total_incidents
      break
    # We don't have all of the incidents, increment the offset and query again
    else
      offset += 50
    end
    
    # Call the PagerDuty API with the appropriate parameters and offset
    data = monthly_pd_query(offset)

    data['incidents'].each do |item|
      incident_number = item['incident_number']
      created_on = Time.parse(item['created_on'])
      resolved_on = Time.parse(item['last_status_change_on'])
      time_open = resolved_on - created_on

      @monthly_resolution_times.push(time_open)
    end
  end

  monthly_mtr = calc_monthly_mtr()
  send_event('monthly_incidents_mtr', { value: monthly_mtr})

end
