class OrdersController < ApplicationController
  def new
    response = {
      "order" => {
        "product_id" => 1,
        "quantity" => 1,
        "address" => "",
        "email" => ""
      },
      "products" => Product.available.select(:id, :name, :price_cents)
    }.as_json

    render json: response
  end

  def create
    order_params = params.require(:order).permit(:product_id, :email, :address, :quantity).merge(user_id: current_user.id)
    order = Order.new(order_params)
    if order.save
      # 非同期Jobの登録
      # TODO: CompleteOrderJob.perform_async(order.id)
      render json: order.as_json, status: 201
      return
    end

    response = {
      "order" => {
        "product_id" => order.product_id,
        "quantity" => order.quantity,
        "address" => order.address,
        "email" => order.email
      },
      "order_errors" => order.errors.full_messages,
      "products" => Product.available.select(:id, :name, :price_cents)
    }.as_json
    render json: response, status: 400
  end

  def show
    order = Order.preload(:product).find(params[:id])
    response = {
      "order" => order.as_json(
        include: { product: { only: %i[name price_cents] } },
        only: %i[id quantity address email charge_id charge_successful charge_completed_at charge_decline_reason email_id fulfillment_request_id],
      )
    }
    render json: response
  rescue ActiveRecord::RecordNotFound
    render json: { "error" => "Order not found" }.as_json, status: 404
  end
end
