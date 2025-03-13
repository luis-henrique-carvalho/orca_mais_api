# frozen_string_literal: true

module TransactionCalculations
  extend ActiveSupport::Concern

  class_methods do
    def total_balance(user_id)
      where(user_id: user_id)
        .sum(:amount)
    end

    def total_income(user_id)
      where(user_id: user_id, transaction_type: :income).sum(:amount)
    end

    def total_expense(user_id)
      where(user_id: user_id, transaction_type: :expense).sum(:amount)
    end

    def transactions_by_category(user_id, order = 'DESC')
      where(user_id: user_id)
        .joins(:category)
        .group('categories.name')
        .select(
          'categories.name AS category_name',
          'COUNT(transactions.id) AS transaction_count',
          'SUM(transactions.amount) AS total_amount'
        )
        .order("total_amount #{order}")
    end

    def transactions_by_month(user_id)
      where(user_id: user_id)
        .group("DATE_TRUNC('month', created_at)")
        .select(
          "DATE_TRUNC('month', created_at) AS month",
          'SUM(amount) AS total_amount'
        )
        .order('month')
    end
  end
end
