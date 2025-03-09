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
class TransactionSerializer < ApplicationSerializer
  identifier :id

  fields :id, :name, :description, :amount, :description, :transaction_type, :created_at, :updated_at

  association :category, blueprint: CategorySerializer

  view :private do
    association :user, blueprint: UserSerializer
  end
end
