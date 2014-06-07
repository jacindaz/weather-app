require 'net/http'
require 'nokogiri'
require 'open-uri'

def forecast_xml(city,state)
  uri = URI("http://api.openweathermap.org/data/2.5/forecast/daily?q=#{city},#{state}&mode=xml&units=metric&cnt=7")
  response = Net::HTTP.get(uri)
  xml_doc = Nokogiri::XML(response)
  return xml_doc
end

puts forecast_xml("Cambridge", "MA")
