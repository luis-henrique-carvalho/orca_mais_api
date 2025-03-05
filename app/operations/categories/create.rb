# frozen_string_literal: true

module Categories
  class Create < ApplicationOperation
    def call(params)
      set_params params

      restrict_safe_params
      create_model

      success @model
    end

    private

    def restrict_safe_params
      @safe_params = @params.permit(:name, :description)
    end

    def create_model
      @model = @current_user.categories.create!(@safe_params)
    end
  end
end
