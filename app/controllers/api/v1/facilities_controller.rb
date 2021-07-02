module Api
  module V1
    class FacilitiesController < Api::V1::BaseController
      def index
        @facilities = pagy(Facility::Base.all)

        render json: @facilities
      end
    end
  end
end
