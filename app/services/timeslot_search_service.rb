class TimeslotSearchService
  FACILITY_MAP = {
    tennis: 'Facility::Tennis',
    football: 'Facility::Football',
    basketball: 'Facility::Basketball',
    volleyball: 'Facility::Volleyball'
  }.freeze

  InvalidFacilityError = Class.new(RuntimeError)

  attr_accessor :facility_type, :date_start, :date_end, :time_start, :time_end

  def search(facility_type: nil, date_from: nil, date_to: nil, time_from: nil, time_to: nil)
    raise InvalidFacilityError if !facility_type.blank? && !FACILITY_MAP.key?(facility_type.to_sym)

    filter_timeslots(facility_type, date_from, date_to, time_from, time_to)
  end

  private

  def filter_timeslots(facility_type, date_from, date_to, time_from, time_to)
    assign_datetime_values(date_from, date_to, time_from, time_to)
    scope = Timeslot.all
    scope = filter_by_facility_type(scope, FACILITY_MAP[facility_type.to_sym]) unless facility_type.blank?
    scope = filter_by_date(scope) unless date_from.blank? && date_to.blank?
    scope = filter_by_time(scope) unless time_from.blank? && time_to.blank?

    scope
  end

  def assign_datetime_values(date_from, date_to, time_from, time_to)
    self.date_start = (date_from || DateTime.now).beginning_of_day
    self.date_end = (date_to || 30.days.from_now).end_of_day

    self.time_start = (time_from || Facility::Base::OPEN_HOURS.first)
    self.time_end = (time_to || Facility::Base::OPEN_HOURS.last)
  end

  def filter_by_facility_type(scope, facility_type)
    scope.joins(:facility).where(facility: { type: facility_type })
  end

  def filter_by_date(scope)
    scope.where('slot_time >= ? AND slot_time <= ?', date_start, date_end)
  end

  def filter_by_time(scope)
    scope.where("CAST(strftime('%H', slot_time) AS INTEGER) >= ?", time_start)
         .where("CAST(strftime('%H', slot_time) AS INTEGER) <= ?", time_end)
  end
end
