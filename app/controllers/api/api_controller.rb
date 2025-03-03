# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include Pagination
    include ErrorHandling
    include RackSessionsFix

    rescue_from ActiveRecord::RecordNotFound, with: ->(e) { render_errors(e, status: :not_found) }

    before_action :configure_permitted_parameters, if: :devise_controller?

    respond_to :json

    def params_with_id(context_params)
      context_params.tap { |new_params| new_params[:id] = params[:id] }
    end

    def authenticate_user!
      token = request.headers['Authorization']&.split&.last

      if token
        begin
          jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
          @current_user = User.find(jwt_payload['sub'])
        rescue JWT::DecodeError
          render json: { errors: {
            auth: I18n.t('devise.failure.unauthenticated')
          } }, status: :unauthorized
        rescue ActiveRecord::RecordNotFound
          render json: { errors: { auth: I18n.t('devise.failure.not_found_in_database', authentication_keys: 'email') } },
                 status: :unauthorized
        end
      else
        render json: { errors: {
          auth: I18n.t('devise.failure.invalid', authentication_keys: 'email')
        } }, status: :unauthorized
      end
    end

    attr_reader :current_user

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name])

      devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name])
    end
  end
end
