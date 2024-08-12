class WelcomeController < ApplicationController
  def show
    render json: {
      message: "Welcome to the API",
      list: %w[a b],
      time: Time.now.getlocal("+09:00").iso8601(3)
    }
  end
end
