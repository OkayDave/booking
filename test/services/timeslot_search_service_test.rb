require 'test_helper'

class TimeslotSearchServiceTest < ActiveSupport::TestCase
  describe '#search' do
    setup do
      @search = TimeslotSearchService.new
    end

    it 'should return all available timeslots when no params specified' do
      results = @search.search

      assert(results.all? { |result| result.is_a?(Timeslot) })
      assert_equal Timeslot.available.count, results.size
    end

    it 'should filter by valid facility type' do
      results = @search.search facility_type: :football
      football_facility_id = facilities(:football1).id

      assert(results.all? { |result| result.facility_id == football_facility_id })
    end

    it 'should return no results if no matching facility' do
      results = @search.search facility_type: :basketball

      assert_equal 0, results.size
    end

    it 'should raise error if invalid facility type is provided' do
      assert_raises 'InvalidFacilityError' do
        @search.search facility_type: :sky_hockey
      end
    end

    it 'should return correct results with single date specified' do
      results = @search.search date_from: DateTime.now.strftime('%Y-%m-%d'),
                               date_to: DateTime.now.strftime('%Y-%m-%d')

      assert(results.all? { |result| result.slot_time.today? })
    end

    it 'should return correct results with future date range' do
      results = @search.search date_from: DateTime.tomorrow.strftime('%Y-%m-%d')

      assert(results.all? { |result| result.slot_time.tomorrow? })
    end

    it 'should return correct results for single time hour specified' do
      results = @search.search time_from: 10, time_to: 10

      assert results.size.positive?
      assert(results.all? { |result| result.slot_time.hour == 10 })
    end

    it 'should return correct results for time range' do
      results = @search.search time_from: 14, time_to: 18

      assert results.size.positive?
      assert(results.all? { |result| (14..18).include?(result.slot_time.hour) })
    end

    it 'should return available tennis courts that are available today between 12 and 2' do
      tennis = facilities(:tennis1)
      results = @search.search facility_type: :tennis,
                               date_from: DateTime.now.strftime('%Y-%m-%d'),
                               date_to: DateTime.now.strftime('%Y-%m-%d'),
                               time_from: 12,
                               time_to: 14

      assert results.size.positive?
      results.each do |result|
        assert_equal tennis.id, result.facility_id
        assert result.slot_time.today?
        assert (12..14).include?(result.slot_time.strftime('%H').to_i)
      end
    end
  end
end
