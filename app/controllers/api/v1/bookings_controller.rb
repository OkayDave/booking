module Api
  module V1
    class BookingsController < ::Api::V1::BaseController
      def index
        @bookings = current_user.bookings

        render json: pagy(@bookings)
      end

      def create
        @booking = current_user.bookings.build booking_params

        @booking.save

        render json: @booking
      end

      def update
        @booking = current_user.bookings.find(params[:id])

        @booking.update booking_params

        render json: @booking
      end

      def destroy
        @booking = current_user.bookings.find(params[:id])

        @booking.cancelled!

        render json: @booking
      end

      private

      def booking_params
        params.require(:booking).permit(:timeslot_id, :notes)
      end
    end
  end
end
