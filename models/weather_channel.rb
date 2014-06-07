class WeatherChannel

  def initialize(api_key)
    @api_key = ENV[api_key]
  end


  #API Call Methods---------------------------------------------------------------------------------------

  def get_current_weather(city, state)
    uri = URI("http://api.wunderground.com/api/#{@api_key}/conditions/q/#{state}/#{city}.json")
    response = Net::HTTP.get(uri)
    weather_data = JSON.parse(response)
    return weather_data
  end

end

