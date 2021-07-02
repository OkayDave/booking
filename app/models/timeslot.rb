class Timeslot < ApplicationRecord
  belongs_to :facility, inverse_of: :timeslots, class_name: 'Facility::Base'
  has_many :bookings, inverse_of: :timeslot, dependent: :destroy

  before_validation :round_slot_time_to_last_hour
  validates :slot_time, presence: true
  validates :facility, presence: true
  validate :excluded_day

  enum state: {
    available: 0,
    unavailable: 1
  }

  private

  def round_slot_time_to_last_hour
    self.slot_time = slot_time.try(:beginning_of_hour)

    errors.add(:slot_time, 'Time is invalid') if slot_time.blank?
  end

  def excluded_day
    return if slot_time.blank?
    return if facility.excluded_dates.none? { |excluded| excluded == "#{slot_time.day}/#{slot_time.month}" }

    errors.add(:slot_time, 'Timeslot not valid for excluded date')
  end
end
