# frozen_string_literal: true

module Api
  class OrdersController < ApplicationController
    def index
      @orders = Order.all

      render json: paginate(@orders, OrderSerializer).to_json, status: :ok
    end

    def show
      @order = Order.find(params[:id])

      render json: @order, except: %i[created_at updated_at]
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Order not found' }, status: :not_found
    end

    def create
      @order = Order.new(order_params)

      if @order.save
        render json: @order, except: %i[created_at updated_at]
      else
        render json: @order.errors
      end
    end

    private

    def order_params
      params.require(:order).permit(:kind, :price, :customer)
    end
  end
end
