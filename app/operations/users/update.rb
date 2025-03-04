# frozen_string_literal: true

module Users
  class Update < ApplicationOperation
    def call(params)
      set_params params

      find_model
      restrict_safe_params
      update_model

      success @model
    end

    private

    def find_model
      @model = User.find(@params[:id])
    end

    def restrict_safe_params
      @safe_params = @params.permit(:email, :cpf, :full_name, :avatar)
    end

    def update_model
      @model.update!(@safe_params)
    end
  end
end
