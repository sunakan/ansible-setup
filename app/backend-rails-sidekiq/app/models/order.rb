# == Schema Information
#
# Table name: orders
#
#  id                                                                                                   :bigint           not null, primary key
#  product_id(Which product is in this order?)                                                          :bigint           not null
#  quantity(How many?)                                                                                  :integer          not null
#  address(What address should it be shipped to?)                                                       :text(65535)      not null
#  email(What email address should be notified?)                                                        :text(65535)      not null
#  created_at(レコード作成日時(メタデータ))                                                             :datetime         not null
#  updated_at(レコード更新日時(メタデータ))                                                             :datetime         not null
#  user_id(Which user placed and paid-for this order?)                                                  :bigint           not null
#  charge_completed_at(If set, when was the charge completed?)                                          :datetime
#  charge_successful(If the charge was completed, was it successful or was it declined?)                :boolean          default(FALSE), not null
#  charge_decline_reason(If the charge was declined, why?)                                              :text(65535)
#  charge_id(If this was paid for, what was the charge id from the remote system?)                      :text(65535)
#  email_id(If the email confirmation went out, what was the id in the remote system?)                  :text(65535)
#  fulfillment_request_id(If the 注文 fulfillment was requested, what was the id in the remote system?) :text(65535)
#
class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :email, presence: true
  validates :address, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  attribute :quantity, :integer, default: 1

  class QuantityMustBeAvailable < ActiveModel::Validator
    def validate(record)
      if record.product.present? && record.quantity.present? && record.quantity > 0
        if record.quantity > record.product.quantity_remaining
          record.errors.add(:quantity, "is more than what is in stock")
        end
      end
    end
  end

  validates_with QuantityMustBeAvailable
end
