module Api
  module V1
    class SessionsController < ::Api::V1::BaseController
      before_action :require_user, except: :create

      def create
        return unauthorized unless current_user.present?

        render json: current_user
      end
    end
  end
end
