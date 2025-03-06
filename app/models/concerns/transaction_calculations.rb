# frozen_string_literal: true

module TransactionCalculations
  extend ActiveSupport::Concern

  class_methods do
    def total_balance(user_id)
      where(user_id: user_id)
        .sum('CASE WHEN transaction_type = 0 THEN amount ELSE -amount END')
    end

    def total_income(user_id)
      where(user_id: user_id, transaction_type: :income).sum(:amount)
    end

    def total_expense(user_id)
      where(user_id: user_id, transaction_type: :expense).sum(:amount)
    end

    def summary_by_category(user_id)
      where(user_id: user_id)
        .joins(:category)
        .group('categories.name')
        .select(
          'categories.name AS category_name',
          'COUNT(transactions.id) AS transaction_count',
          'SUM(CASE WHEN transaction_type = 0 THEN amount ELSE -amount END) AS total_amount'
        )
    end

    def summary_by_category_with_income_expense(user_id)
      where(user_id: user_id)
        .joins(:category)
        .select(
          'categories.name AS category_name',
          'COUNT(transactions.id) AS transaction_count',
          'SUM(CASE WHEN transaction_type = 0 THEN amount ELSE -amount END) AS total_amount',
          'SUM(CASE WHEN transaction_type = 0 THEN amount ELSE 0 END) AS total_income',
          'SUM(CASE WHEN transaction_type = 1 THEN amount ELSE 0 END) AS total_expense'
        )
    end

    def monthly_totals(user_id)
      where(user_id: user_id)
        .group("DATE_TRUNC('month', created_at)")
        .sum('CASE WHEN transaction_type = 0 THEN amount ELSE -amount END')
    end
  end
end
