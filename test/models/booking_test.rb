require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  describe 'state management' do
    setup do
      @ts = timeslots(:tennis1_1)
      user = users(:dave)

      @booking = Booking.create(timeslot: @ts, user: user)
    end

    it 'should mark timeslot as unavailable after creation' do
      assert @booking.persisted?
      assert @booking.booked?

      assert @ts.reload.unavailable?
    end

    it 'should mark timeslot as available after destruction' do
      assert @ts.reload.unavailable?

      @booking.destroy!

      assert @ts.reload.available?
    end

    it 'should mark timeslot as available after cancellation' do
      assert @ts.reload.unavailable?

      @booking.cancelled!

      assert @ts.reload.available?
    end
  end
end
