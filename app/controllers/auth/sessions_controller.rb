# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength

module Auth
  class SessionsController < Devise::SessionsController
    include RackSessionsFix

    respond_to :json

    private

    def respond_with(resource, _opt = {})
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        code: 200,
        message: 'Logged in successfully.',
        token: @token,
        user: UserSerializer.render_as_json(resource)
      }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                 Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end
  end
end

# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
