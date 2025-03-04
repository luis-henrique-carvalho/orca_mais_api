# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      before_action :authenticate_user!, only: %i[index create]

      def index
        result = ::Categories::Filter.call(params:)

        if result.success?
          render json: paginate(result.payload, ::CategorySerializer).to_json, status: :ok
        else
          render_errors(result.error, status: result.status)
        end
      end

      def create
        result = ::Categories::Create.call(params: create_params, current_user:)

        if result.success?
          render json: ::CategorySerializer.render(result.payload, view: :private, root: :data)
        else
          render_errors(result.error, status: result.status)
        end
      end

      private

      def create_params
        params.require(:category)
      end
    end
  end
end
