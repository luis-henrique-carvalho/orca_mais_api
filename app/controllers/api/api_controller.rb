# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include Pagination
    include ErrorHandling

    rescue_from ActiveRecord::RecordNotFound, with: ->(e) { render_errors(e, status: :not_found) }

    before_action :configure_permitted_parameters, if: :devise_controller?

    respond_to :json

    def params_with_id(context_params)
      context_params.tap { |new_params| new_params[:id] = params[:id] }
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name])

      devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name])
    end
  end
end
