require 'net/http'
class WelcomeController < ApplicationController
  def show
    response = Net::HTTP.get_response(URI("#{api_endpoint}/"))

    case response
    when Net::HTTPSuccess
      render :show, locals: { response: JSON.parse(response.body) }
    else
      raise "Unexpected response: #{response}"
    end
  end
end
