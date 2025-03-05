# frozen_string_literal: true

module Categories
  class Filter < ApplicationOperation
    def call(params)
      set_params params

      define_query
      filter_by_user_or_global
      search

      success @query
    end

    def define_query
      @query = Category.all
    end

    def filter_by_user_or_global
      return if (value = @params.dig(:q, :user_id_eq)).blank?

      @query = @query.by_user_or_global(value)
    end

    def search
      return if @params[:search].blank?

      @query = @query.search(@params[:search])
    end
  end
end
