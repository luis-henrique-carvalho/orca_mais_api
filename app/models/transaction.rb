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
class Transaction < ApplicationRecord
  include PgSearch::Model
  include TransactionCalculations

  belongs_to :category
  belongs_to :user

  enum :transaction_type, {
    income: 0,
    expense: 1
  }

  validates :name, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :transaction_type, presence: true

  scope :by_category, ->(category_id) { where(category_id: category_id) }

  pg_search_scope :search, against: :name, using: {
    tsearch: { prefix: true }
  }

  before_save :set_amount_sign

  private

  def set_amount_sign
    if expense? && amount.positive?
      self.amount = -amount
    elsif income? && amount.negative?
      self.amount = amount.abs
    end
  end
end
