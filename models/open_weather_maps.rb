
class OpenMapsWeather

  #API Call Methods---------------------------------------------------------------------------------------

  def forecast_xml(city,state)
    uri = URI("http://api.openweathermap.org/data/2.5/forecast/daily?q=#{city},#{state}&mode=xml&units=metric&cnt=7")
    response = Net::HTTP.get(uri)
    xml_doc = Nokogiri::XML(response)
    return xml_doc
  end

  def get_current_weather(city,state)
    uri = URI("http://api.openweathermap.org/data/2.5/weather?q=#{city},#{state}")
    response = Net::HTTP.get(uri)
    weather_data = JSON.parse(response)
    return weather_data
  end

  def weather_icon(icon_id)
    url = "http://openweathermap.org/img/w/#{icon_id}.png"
    return url
  end


  #Kelvin, Celcius, Farenheit Conversion Methods----------------------------------------------------------

  def convert_F(kelvin_temp)
    celcius = kelvin_temp - 273.15
    farenheit = (celcius * 1.8) + 32
    return farenheit
  end

  def celcius_to_faren(hash)
    hash.each do |key,value|
      new_value = (value.to_f * 1.8) + 32
      rounded = new_value.round(1)
      hash[key] = rounded
    end
    return hash
  end

  def celcius_to_faren_num(n)
    farenheit = (n * 1.8) + 32
    return farenheit.to_i
  end

  #Returning Data from XML---------------------------------------------------------------------------------

  def current_weather_hash(xml_data)
    temperature = convert_F(xml_data["main"]["temp"]).to_i
    temp_min = convert_F(xml_data["main"]["temp_min"]).to_i
    temp_max = convert_F(xml_data["main"]["temp_max"]).to_i
    description = xml_data["weather"][0]["description"]
    weather_icon_id = xml_data["weather"][0]["icon"]
    weather_icon_url = weather_icon(weather_icon_id)

    current_weather_hash = { :current_weather => temperature, :high => temp_max, :low => temp_min,
                            :description => description, :icon_id => weather_icon_id, :icon_url => weather_icon_url}
    return current_weather_hash
  end

  def icon_url_array(forecast_hash)
    icon_url_array = []
    forecast_hash.each do |day|
      icon_id = day[:var]
      url = weather_icon(icon_id)
      icon_url_array << url
    end
    return icon_url_array
  end


  #Parse XML Data---------------------------------------------------------------------------------

  def xml_array_nested_hash(xml_file_path, xml_doc)
    array_of_hashes = []

    xml_doc.xpath(xml_file_path).each do |elements|
      nested_hash = {}
      #puts "outer loop: attributes #{elements}"
      elements.each do |key, value|
        #puts "each loop: key/value is #{key}, #{value}"
        nested_hash[key.to_sym] = value
        #binding.pry
      end
      array_of_hashes << nested_hash
    end
    return array_of_hashes
  end

end



















