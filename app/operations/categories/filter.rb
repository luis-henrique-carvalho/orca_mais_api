# frozen_string_literal: true

module Categories
  class Filter < ApplicationOperation
    def call(params)
      set_params params

      define_query
      search

      success @query
    end

    def define_query
      @query = Category.all
    end

    def search
      return if @params[:search].blank?

      @query = @query.search(@params[:search])
    end
  end
end
