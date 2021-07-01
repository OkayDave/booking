module Api
  module V1
    class TimeslotsController < ::Api::V1::BaseController
      def index
        @timeslots = Timeslot.all

        render json: pagy(@timeslots)
      end
    end
  end
end
