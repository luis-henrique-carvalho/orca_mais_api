# frozen_string_literal: true

module Transactions
  class Update < ApplicationOperation
    def call(params)
      set_params params

      set_model
      restrict_safe_params
      update_model

      success @model
    end

    private

    def set_model
      @model = @current_user.transactions.find(@params[:id])
    end

    def restrict_safe_params
      @safe_params = @params.permit(:name, :amount, :category_id, :transaction_type, :description)
    end

    def update_model
      @model.update!(@safe_params)
    end
  end
end
