# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApiController
      before_action :authenticate_user!, only: %i[index create show update destroy]
      before_action :set_transaction, only: %i[show destroy]

      def index
        result = ::Transactions::Filter.call(params:, current_user:)

        if result.success?
          render json: paginate(result.payload, ::TransactionSerializer).to_json, status: :ok
        else
          render_errors(result.error, status: result.status)
        end
      end

      def show
        result = ::Transactions::Show.call(params: @transaction)

        if result.success?
          render json: ::TransactionSerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      def create
        result = ::Transactions::Create.call(params: create_params, current_user:)

        if result.success?
          render json: ::TransactionSerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      def update
        result = ::Transactions::Update.call(params: update_params, current_user:)

        if result.success?
          render json: ::TransactionSerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      def destroy
        result = ::Transactions::Destroy.call(params: @transaction)

        if result.success?
          render json: { message: 'Transaction deleted successfully' }, status: :ok
        else
          render_errors(result.error, status: result.status)
        end
      end

      private

      def create_params
        params.require(:transaction)
      end

      def set_transaction
        @transaction = current_user.transactions.find(params[:id])
      end

      def update_params
        params_with_id(params.require(:transaction))
      end
    end
  end
end
