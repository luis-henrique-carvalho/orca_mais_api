# frozen_string_literal: true

class TransactionSerializer < ApplicationSerializer
  identifier :id

  fields :id, :name, :description, :amount, :description, :transaction_type, :created_at, :updated_at

  association :category, blueprint: CategorySerializer

  view :private do
    association :user, blueprint: UserSerializer
  end
end
