# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id               :uuid             not null, primary key
#  amount           :decimal(12, 3)   not null
#  description      :string
#  name             :string           not null
#  transaction_type :integer          default("income"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  category_id      :uuid             not null
#  user_id          :uuid             not null
#
# Indexes
#
#  index_transactions_on_category_id  (category_id)
#  index_transactions_on_name         (name) UNIQUE
#  index_transactions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :transaction do
    sequence(:name) { |n| "#{Faker::Commerce.product_name} #{n}" }
    amount { Faker::Number.decimal(l_digits: 3) }
    transaction_type { %i[income expense].sample }
    description { Faker::Lorem.sentence }

    user { association(:user) }
    category { association(:category) }
  end
end
