require 'net/http'
require 'time'

class TimesController < ApplicationController

  def create
    session[:location] = params[:searchTextField]  #  Saves Google Places autocomplete to session.
    geocode_location_to_latlong(session[:location])
    lookup_raw_time_for_location(session[:lat], session[:long])
    make_time_pretty(session[:raw_time])
    redirect_to root_path
  end

private
  def geocode_location_to_latlong(location)
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(location)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    session[:lat], session[:long] = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
  rescue
    false
  end

  def lookup_raw_time_for_location(lat, long)
    response = Net::HTTP.get_response(URI.parse("http://ws.geonames.org/timezoneJSON?lat=#{Rack::Utils.escape(lat)}&lng=#{Rack::Utils.escape(long)}&style=full"))    
    json = ActiveSupport::JSON.decode(response.body)
    session[:raw_time] = json["time"]
  rescue
    false
  end

  def make_time_pretty(raw_time)
    session[:time] = raw_time.to_time.strftime("%l:%M %P on %A %B %e")
  end
end