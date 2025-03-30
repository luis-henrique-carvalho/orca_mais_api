# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
module Api
  module Auth
    class SessionsController < Devise::SessionsController
      include RackSessionsFix

      skip_before_action :verify_authenticity_token

      respond_to :json

      def refresh_token
        refresh_token = params[:refresh_token]

        return render json: { message: 'Token is required' }, status: :unauthorized if refresh_token.nil?

        begin
          payload = JWT.decode(refresh_token, Rails.application.credentials.devise_jwt_secret_key, true)[0]

          current_user = User.find_by(id: payload['sub'], jti: payload['jti'])

          return render json: { message: 'Token is invalid' }, status: :unauthorized if current_user.nil?

          current_user.update(jti: SecureRandom.uuid)
          new_token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil).first
          refresh_token = RefreshTokenGenerator.new(current_user).refresh_token

           render json: {
            message: 'Token refreshed',
            token: new_token,
            refresh_token: refresh_token
          }, status: :ok
        rescue JWT::VerificationError
          render json: { message: 'Token is invalid' }, status: :unauthorized
        end
      end

      private

      def respond_with(resource, _opt = {})
        @token = request.env['warden-jwt_auth.token']
        headers['Authorization'] = @token

        refresh_token = RefreshTokenGenerator.new(resource).refresh_token

        render json: {
          message: 'Logged in successfully.',
          token: @token,
          refresh_token: refresh_token,
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
          response.delete_cookie('refresh_token')

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
