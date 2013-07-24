require 'net/http'
require 'pry'

class TimesController < ApplicationController

  def create
    session[:location] = params[:searchTextField]
    do_geocode(session[:location])
    do_timelookup(session[:lat], session[:long])
    redirect_to root_path
  end

  def do_geocode(location)
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(location)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    session[:lat], session[:long] = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
  rescue
    false # For now, fail silently...
  end

  def do_timelookup(lat, long)
    response = Net::HTTP.get_response(URI.parse("http://ws.geonames.org/timezoneJSON?lat=#{Rack::Utils.escape(lat)}&lng=#{Rack::Utils.escape(long)}&style=full"))    
    json = ActiveSupport::JSON.decode(response.body)
    session[:time] = json["time"]
  rescue
    false # For now, fail silently...
  end
endr