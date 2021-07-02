class TimeslotGenerationService
  InvalidFacilityError = Class.new(RuntimeError)
  InvalidDaysError = Class.new(RuntimeError)

  def generate_timeslots(facility:, number_of_days: 30)
    raise InvalidFacilityError if facility.blank? || !facility.is_a?(::Facility::Base)
    raise InvalidDaysError unless number_of_days.is_a?(Integer)

    timeslots = (0...number_of_days).map { |day| build_timeslot_for_day(facility, day) }.compact.flatten

    Timeslot.import(timeslots, on_duplicate_key_ignore: true)
  end

  private

  def build_timeslot_for_day(facility, day)
    hours = facility.class::OPEN_HOURS
    base_time = DateTime.parse('00:00') + day.days

    hours.map do |hour|
      slot_time = base_time + hour.hours
      Timeslot.new facility_id: facility.id, slot_time: slot_time
    end
  end
end
