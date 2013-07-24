class TimeController < ApplicationController

  def create
    session[:location] = params[:searchTextField]
    redirect_to root_path
  end
end