# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
module Api
  module Auth
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token

      respond_to :json

      private

      def respond_with(resource, _opt = {})
        @token = request.env['warden-jwt_auth.token']
        headers['Authorization'] = @token

        render json: {

            message: 'Logged in successfully.',
            token: @token,
            user: UserSerializer.render_as_json(resource)

        }, status: :ok
      end

      def respond_to_on_destroy
        if request.headers['Authorization'].present?
          secret_key = Rails.application.credentials.devise_jwt_secret_key || ENV.fetch('DEVISE_JWT_SECRET_KEY', nil)

          jwt_payload = JWT.decode(request.headers['Authorization'].split.last, secret_key).first
          current_user = User.find(jwt_payload['sub'])
        end

        if current_user
          render json: {
            message: 'Logged out successfully.'
          }, status: :ok
        else
          render json: {
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
