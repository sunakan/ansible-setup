# == Schema Information
#
# Table name: products
#
#  id                                                     :bigint           not null, primary key
#  name(Name of the product)                              :string(255)      not null
#  quantity_remaining(How many of this product are left?) :integer          not null
#  price_cents(Price of one product, in cents)            :integer          not null
#  created_at(レコード作成日時(メタデータ))               :datetime         not null
#  updated_at(レコード更新日時(メタデータ))               :datetime         not null
#
class Product < ApplicationRecord
  def self.available = self.where("quantity_remaining > 0")
end
