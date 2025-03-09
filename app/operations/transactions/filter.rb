# frozen_string_literal: true

module Transactions
  class Filter < ApplicationOperation
    def call(params)
      set_params params

      define_query

      search
      define_includes
      filter_by_category
      filter_by_created_at_less_than_equals
      filter_by_created_at_greater_than_equals

      success @query
    end

    def define_query
      @query = @current_user.transactions.distinct
    end

    def define_includes
      @query = @query.includes(:category)
    end

    def filter_by_category
      return if (value = @params.dig(:q, :category_id_eq)).blank?

      @query = @query.by_category(value)
    end

    def filter_by_created_at_less_than_equals
      return if (end_date = @params.dig(:q, :created_at_lteq)).blank?

      @query = @query.where(created_at: ..Date.parse(end_date).end_of_day)
    end

    def filter_by_created_at_greater_than_equals
      return if (start_date = @params.dig(:q, :created_at_gteq)).blank?

      @query = @query.where(created_at: Date.parse(start_date).beginning_of_day..)
    end

    def search
      return if @params[:search].blank?

      @query = @query.search(@params[:search]).with_pg_search_rank
    end
  end
end
