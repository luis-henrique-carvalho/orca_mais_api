# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  customer   :string           not null
#  kind       :string           not null
#  price      :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OrderSerializer < ApplicationSerializer
  identifier :id

  fields :id, :customer, :kind, :price
end
