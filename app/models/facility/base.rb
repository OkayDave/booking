module Facility
  class Base < ApplicationRecord
    VALID_TYPES = %w[
      Facility::Tennis
      Facility::Volleyball
      Facility::Football
      Facility::Basketball
    ].freeze

    # Standard opening times for the facility (10am - 7pm)
    OPEN_HOURS = (10...20).freeze

    # Dates when the facility is completely closed
    EXCLUDED_DATES = [
      '25/12'
    ].freeze

    validates :type, presence: true, inclusion: { in: VALID_TYPES }
    validates :name, presence: true, length: { minimum: 1, maximum: 255 }

    has_many :timeslots, inverse_of: :facility, foreign_key: :facility_id, class_name: 'Timeslot', dependent: :destroy
    has_many :bookings, through: :timeslots

    def serializable_hash(opts = {})
      opts = {
        methods: %i[type]
      }.update(opts)

      super(opts)
    end

    def excluded_dates
      EXCLUDED_DATES
    end
  end
end
