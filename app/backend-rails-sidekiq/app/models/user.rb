# == Schema Information
#
# Table name: users
#
#  id                                                                                   :bigint           not null, primary key
#  email(Email address of this user)                                                    :string(255)      not null
#  payments_customer_id(ID of 顧客 in our payments service)                             :string(255)      not null
#  payments_payment_method_id(ID of 顧客 chosen payment method in our payments service) :string(255)      not null
#  created_at(レコード作成日時(メタデータ))                                             :datetime         not null
#  updated_at(レコード更新日時(メタデータ))                                             :datetime         not null
#
class User < ApplicationRecord
  has_many :orders
end
