# frozen_string_literal: true

# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[show update]
      before_action :authenticate_user!, only: %i[show update]

      def show
        result = ::Users::Show.call(params: @user)

        if result.success?
          render json: ::UserSerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      def update
        result = ::Users::Update.call(params: update_params)

        if result.success?
          render json: ::UserSerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def create_params
        params.require(:user)
      end

      def update_params
        params_with_id(params.require(:user))
      end
    end
  end
end
