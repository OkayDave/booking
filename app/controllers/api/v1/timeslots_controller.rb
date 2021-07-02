module Api
  module V1
    class TimeslotsController < ::Api::V1::BaseController
      def index
        @timeslots = TimeslotSearchService.new.search facility_type: search_params[:facility_type],
                                                      date_from: search_params[:date_from],
                                                      date_to: search_params[:date_to],
                                                      time_from: search_params[:time_from],
                                                      time_to: search_params[:time_to]

        render json: pagy(@timeslots)
      end

      private

      def search_params
        params.fetch(:search, {}).permit(:facility_type, :date_from, :date_to, :time_from, :time_to)
      end
    end
  end
end
