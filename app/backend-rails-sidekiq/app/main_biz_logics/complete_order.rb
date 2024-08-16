# Command pattern
# executeで実行
class CompleteOrder
  def initialize(order, user_payment_customer_id, user_payment_payment_method_id)
    @order = order
    # 支払いサービスにて利用
    @user_payment_customer_id = user_payment_customer_id
    @user_payment_payment_method_id = user_payment_payment_method_id
  end

  def execute
    # todo: charge api の用意
    # PaymentsServiceのchargeメソッドの結果で分岐
    # 今は必ず成功という前提
    @order.update!(
      charge_id: "charge_id-#{@order.id}",
      charge_completed_at: Time.zone.now,
      charge_successful: true
    )
    # todo: メールを送る処理を非同期にする
    @order.update!(
      email_id: "email_id-#{@order.id}"
    )
    # todo: 注文配送処理を非同期にする
    @order.update!(
      fulfillment_request_id: "fulfillment_request_id-#{@order.id}"
    )
  end
end

# - 非同期Job: CompleteOrder(支払い)
#   - 非同期Job: SendMailNotification(メール送信)
#     - 非同期Job: RequestOrderFulfillment(注文配送処理)
