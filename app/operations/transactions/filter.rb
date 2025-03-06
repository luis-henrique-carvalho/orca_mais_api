# frozen_string_literal: true

module Transactions
  class Filter < ApplicationOperation
    def call(params)
      set_params params

      define_query
      define_includes
      filter_by_category
      search

      success @query
    end

    def define_query
      @query = @current_user.transactions
    end

    def define_includes
      @query = @query.includes(:category)
    end

    def filter_by_category
      return if (value = @params.dig(:q, :category_id_eq)).blank?

      @query = @query.by_category(value)
    end

    def search
      return if @params[:search].blank?

      @query = @query.search(@params[:search])
    end
  end
end
