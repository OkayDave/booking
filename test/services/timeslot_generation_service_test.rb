require 'test_helper'

class TimeslotGenerationServiceTest < ActiveSupport::TestCase
  describe '#generate_timeslots' do
    setup do
      @t1 = facilities(:tennis1)
    end

    it 'should raise error if no facility provided' do
      assert_raises 'InvalidFacilityError' do
        TimeslotGenerationService.new.generate_timeslots(facility: nil)
      end
    end

    it 'should raise error if facility is invalid' do
      assert_raises 'InvalidFacilityError' do
        TimeslotGenerationService.new.generate_timeslots(facility: Timeslot.new)
      end
    end

    it 'should raise error if provided days is not an integer' do
      assert_raises 'InvalidDaysError' do
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: @t1)
      end
    end

    it 'should create timeslots for provided facility' do
      Timeslot.delete_all
      expected_count = 10 # 1 day * 10 hours
      assert_difference 'Timeslot.count', expected_count do
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: 1)
      end
    end

    it 'should not create duplicate timeslots when repeated' do
      Timeslot.delete_all
      expected_count = 10 # 1 day * 10 hours
      assert_difference 'Timeslot.count', expected_count do
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: 1)
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: 1)
      end
    end

    it 'should create timeslots for multiple days' do
      Timeslot.delete_all
      expected_count = 20 # 2 days * 10 hours
      assert_difference 'Timeslot.count', expected_count do
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: 2)
      end
    end

    it 'should not create timeslots for excluded days' do
      Timeslot.delete_all
      tomorrow = DateTime.tomorrow
      ::Facility::Base.any_instance.stubs(:excluded_dates).returns(["#{tomorrow.day}/#{tomorrow.month}"])

      expected_count = 20 # today, not tomorrow, overmorrow
      assert_difference 'Timeslot.count', expected_count do
        TimeslotGenerationService.new.generate_timeslots(facility: @t1, number_of_days: 3)
      end
    end
  end
end
