# frozen_string_literal: true

module Transactions
  class Show < ApplicationOperation
    def call(transaction)
      success transaction
    end
  end
end
