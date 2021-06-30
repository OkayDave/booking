module Api
  module V1
    class BaseController < ::ApplicationController
      before_action :require_user

      def unauthorized
        render json: { error: :unauthorized }, status: :unauthorized
      end

      def bad_request
        render json: { error: :bad_request }, status: :bad_request
      end

      private

      def require_user
        return unauthorized unless current_user.present?
      end
    end
  end
end
