require 'net/http'
class WelcomeController < ApplicationController
  def show
    response = Net::HTTP.get_response(
      URI("#{api_endpoint}/"),
      { 'Accept' => 'application/json' }
    )
    render :show, locals: { response: JSON.parse(response.body) }
  end
end
