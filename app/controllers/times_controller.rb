require 'net/http'
require 'pry'

class TimesController < ApplicationController

  def create
    session[:location] = params[:searchTextField]
    geocode_location_to_latlong(session[:location])
    lookup_time_for_location(session[:lat], session[:long])
    redirect_to root_path
  end

  def geocode_location_to_latlong(location)
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(location)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    session[:lat], session[:long] = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
  rescue
    false # For now, fail silently...
  end

  def lookup_time_for_location(lat, long)
    response = Net::HTTP.get_response(URI.parse("http://ws.geonames.org/timezoneJSON?lat=#{Rack::Utils.escape(lat)}&lng=#{Rack::Utils.escape(long)}&style=full"))    
    json = ActiveSupport::JSON.decode(response.body)
    session[:time] = json["time"]
  rescue
    false # For now, fail silently...
  end
end