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
FactoryBot.define do
  factory :order do
    kind  { Faker::Name.name }
    price { Faker::Number.decimal(l_digits: 2) }
    customer { Faker::Name.name }
  end
end
