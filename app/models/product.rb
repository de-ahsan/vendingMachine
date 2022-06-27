# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  available_count :integer          default(0)
#  name            :string           not null
#  price           :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  seller_id       :bigint           not null, indexed
#
# Indexes
#
#  index_products_on_seller_id  (seller_id)
#
class Product < ApplicationRecord
  belongs_to :seller, class_name: 'User', foreign_key: true

end
