class OrdersController < ApplicationController
  def new
    response = Net::HTTP.get_response(
      URI("#{api_endpoint}/orders/new"),
      { 'Accept' => 'application/json' }
    )

    render :new, locals: { response: JSON.parse(response.body).merge({'authenticity_token' => form_authenticity_token}) }
  end

  def create
    permitted = params.require(:order).permit(:product_id, :email, :address, :quantity)
    response = Net::HTTP.post(
      URI("#{api_endpoint}/orders/"),
      permitted.to_json,
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
    )

    case response
    when Net::HTTPCreated
      order = JSON.parse(response.body)
      redirect_to "/orders/#{order['id']}"
    when Net::HTTPBadRequest
      render :new, locals: { response: JSON.parse(response.body).merge({'authenticity_token' => form_authenticity_token}) }
    else
      raise "Unexpected response: #{response.inspect}"
    end
  end

  def show
    response = Net::HTTP.get_response(
      URI("#{api_endpoint}/orders/#{params[:id]}"),
      { 'Accept' => 'application/json' }
    )

    case response
    when Net::HTTPOK
      render :show, locals: { response: JSON.parse(response.body) }
    when Net::HTTPNotFound
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    else
      raise "Unexpected response: #{response.inspect}"
    end
  end
end
