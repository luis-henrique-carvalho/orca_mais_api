# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApiController
      before_action :authenticate_user!, only: %i[index]

      def index
        result = ::Categories::Filter.call(params:)

        if result.success?
          render json: paginate(result.payload, ::CategorySerializer).to_json, status: :ok
        else
          render_errors(result.error, status: result.status)
        end
      end
    end
  end
end
