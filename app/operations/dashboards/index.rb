# frozen_string_literal: true

module Dashboards
  class Index < ApplicationOperation
    def call(params)
      set_params params

      set_user_id @current_user.id

      success(
        total_balance: Transaction.total_balance(@user_id),
        total_income: Transaction.total_income(@user_id),
        total_expense: Transaction.total_expense(@user_id),
        incomes_by_category: Transaction.income.transactions_by_category(@user_id),
        expenses_by_category: Transaction.expense.transactions_by_category(@user_id, 'ASC'),
        transactions_by_month: Transaction.transactions_by_month(@user_id)
      )
    end
  end
end
