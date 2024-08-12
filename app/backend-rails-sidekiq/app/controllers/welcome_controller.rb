class WelcomeController < ApplicationController
  def show
    render json: { message: "Welcome to the API" }
  end
end
