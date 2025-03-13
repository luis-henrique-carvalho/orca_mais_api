# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApiController
      before_action :authenticate_user!, only: %i[index]

      def index
        result = ::Dashboards::Index.call(params:, current_user:)

        if result.success?
          render json: result.payload, status: :ok
        else
          render_errors(result.error, status: result.status)
        end
      end
    end
  end
end
