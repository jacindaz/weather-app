require 'sinatra'
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'pry'


#CLASSES and METHODS----------------------------------------------------------------------------
require_relative 'models/open_weather_maps'



def today_date
  return Date.today
end


#ROUTES AND VIEWS----------------------------------------------------------------------------------

get '/' do


  @title = "Check the Weather!"


  if params[:query] == nil
    @city = "Cambridge"
    @state = "MA"
  else
    split = params[:query].split(',' || " ")
    cleaned_array = split.collect{ |query_item| query_item.strip }
    @city = cleaned_array[0]
    @state = cleaned_array[1]
  end

  @current_weather_object = OpenMapsWeather.new

  #Current Weather Variables-----------------------------------------------------------------------

  @weather_info = @current_weather_object.get_current_weather(@city, @state)
  @current_weather_hash = @current_weather_object.current_weather_hash(@weather_info)

  # #Weather Forecast Variables-----------------------------------------------------------------------
  @date = today_date
  @weather_forecast_object = OpenMapsWeather.new
  @xml_doc = @weather_forecast_object.forecast_xml(@city, @state)

  @temp_array = []
  @xml_doc.xpath('/weatherdata/forecast/time/temperature').each do |element|
    @temp_hash2 = {}
    element.each do |key,value|
      @temp_hash2[key.to_sym] = @weather_forecast_object.celcius_to_faren_num(value.to_f)
    end
    @temp_array << @temp_hash2
  end

  #Pulling in Image icon id's for weather pictures-----------------------------------------------------
  @forecast_icon_object = OpenMapsWeather.new
  @icon_array = @forecast_icon_object.xml_array_nested_hash('/weatherdata/forecast/time/symbol', @xml_doc)
  @icon_url_array = @forecast_icon_object.icon_url_array(@icon_array)

  erb :index
end
