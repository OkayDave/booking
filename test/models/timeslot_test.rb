require 'test_helper'

class TimeslotTest < ActiveSupport::TestCase
  describe 'slot_time' do
    it 'be invalid if not a valid time' do
      ts = Timeslot.new facility_id: 1

      ts.slot_time = 'today'

      refute ts.valid?
      assert_match(/Time is invalid/, ts.errors.full_messages.first)
    end

    it 'be valid if a valid time' do
      ts = Timeslot.new facility_id: 1

      ts.slot_time = DateTime.now

      assert ts.valid?
    end

    it 'be invalid if set to excluded day' do
      ts = Timeslot.new facility_id: 1

      ts.slot_time = DateTime.parse('2021-12-25 10:00')

      refute ts.valid?
      assert_match(/excluded date/, ts.errors.full_messages.first)
    end

    it 'rounds to beginning of hour' do
      ts = Timeslot.new facility_id: 1

      ts.slot_time = DateTime.parse('01/01/2021 10:24')

      assert ts.valid?
      assert_match(/2021-01-01 10:00/, ts.slot_time.to_s)
    end
  end
end
