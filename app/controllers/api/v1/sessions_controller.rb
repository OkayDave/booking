module Api
  module V1
    class SessionsController < ::Api::V1::BaseController
      def create
        return unauthorized unless current_user.present?

        render json: current_user
      end
    end
  end
end
