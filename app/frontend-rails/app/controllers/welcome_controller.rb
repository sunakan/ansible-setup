require 'net/http'
class WelcomeController < ApplicationController
  def show
    response = Net::HTTP.get(
      URI("#{api_endpoint}/"),
      { 'Accept' => 'application/json' }
    )

    render :show, locals: { response: JSON.parse(response) }
  end
end
