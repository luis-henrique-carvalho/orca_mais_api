# frozen_string_literal: true

module Transactions
  class Destroy < ApplicationOperation
    def call(transaction)
      destroy_transaction transaction

      success nil
    end

    private

    def destroy_transaction(transaction)
      transaction.destroy!
    end
  end
end
