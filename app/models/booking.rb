class Booking < ApplicationRecord
  belongs_to :user, inverse_of: :bookings
  belongs_to :timeslot, inverse_of: :bookings

  has_one :facility, through: :timeslot

  enum state: {
    booked: 0,
    cancelled: 1
  }

  after_save :update_timeslot_state
  after_destroy :update_timeslot_state

  private

  def update_timeslot_state
    timeslot.unavailable! if booked?
    timeslot.available! if cancelled? || !persisted?
  end
end
