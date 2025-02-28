# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  customer   :string           not null
#  kind       :string           not null
#  price      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Order < ApplicationRecord
  validates :kind, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :customer, presence: true
end
