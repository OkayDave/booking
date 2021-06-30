module Api
  module V1
    class BaseController < ::ApplicationController
      def unauthorized
        render json: { error: :unauthorized }, status: :unauthorized
      end

      def bad_request
        render json: { error: :bad_request }, status: :bad_request
      end
    end
  end
end
