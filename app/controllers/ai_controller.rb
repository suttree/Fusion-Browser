class AiController < ApplicationController
  def index
    @greeting = "Hello Leila, I hope you have the volume turned up!"
  end
  def say
    @greeting = params[:q]
    render :partial => 'say'
  end
end
