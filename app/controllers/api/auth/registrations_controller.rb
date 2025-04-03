# frozen_string_literal: true

module Api
  module Auth
    class RegistrationsController < Devise::RegistrationsController
      include RackSessionsFix

      skip_before_action :verify_authenticity_token

      respond_to :json

      private

      def sign_up_params
        params.expect(user: %i[email password password_confirmation])
      end

      def respond_with(resource, _opts = {})
        if resource.persisted?
          @token = request.env['warden-jwt_auth.token']
          headers['Authorization'] = @token

          refresh_token = RefreshTokenGenerator.new(resource).refresh_token

          render json: {
            message: 'Signed up successfully.',
            token: @token,
            user: UserSerializer.render_as_json(resource),
            refresh_token: refresh_token
          }
        else
          render json: {
            message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
