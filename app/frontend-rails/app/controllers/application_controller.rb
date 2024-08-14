class ApplicationController < ActionController::Base
  private

  def api_endpoint
    ENV.fetch('API_ENDPOINT', "http://localhost:3000")
  end
end
