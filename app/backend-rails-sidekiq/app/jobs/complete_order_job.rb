class CompleteOrderJob < ApplicationJob
  def perform(order_id)
    order = Order.preload(:user).find(order_id)
    user = order.user
    1.upto(20).each {|i| p "order_id: #{order_id}, #{i}sec経過"; sleep 1}
    CompleteOrder.new(order, user.payments_customer_id, user.payments_payment_method_id).execute
  end
end
