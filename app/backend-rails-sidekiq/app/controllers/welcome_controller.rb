class WelcomeController < ApplicationController
  def show
    response = {
      "service_statuses" => ServiceStatus.all,
      "order_ids" => Order.pluck(:id).sort
    }.as_json
    render json: response
  end
end
