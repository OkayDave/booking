module Api
  module V1
    class FacilitiesController < Api::V1::BaseController
      def index
        @facilities = pagy(FacilitySearchService.new.search({}))

        render json: @facilities
      end
    end
  end
end
