require 'net/http'

class TimesController < ApplicationController

  def create
    session[:location] = params[:searchTextField]
    do_geocode(session[:location])
    redirect_to root_path
  end

  def do_geocode(location)
    response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(location)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)
    session[:lat], session[:long] = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
  rescue
    false # For now, fail silently...
  end
end