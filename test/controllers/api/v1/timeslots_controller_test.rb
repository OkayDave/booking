require 'test_helper'

module Api
  module V1
    class TimeslotsControllerTest < ActionDispatch::IntegrationTest
      describe '#index' do
        it 'should return unauthorized without user' do
          get '/api/v1/timeslots'

          assert_response :unauthorized
        end

        it 'should return all timeslots without extra params' do
          authget '/api/v1/timeslots'

          json = json_body
          pagy = json[0]
          timeslots = json[1]
          assert_response :ok

          assert json.is_a?(Array)

          assert pagy.is_a?(Hash)
          assert_equal %w[vars count items page outset last pages offset from to prev next], pagy.keys

          assert timeslots.is_a?(Array)
          assert Timeslot.count, timeslots.size
          assert_equal %w[id slot_time facility_id created_at updated_at state], timeslots.first.keys
          assert_equal timeslots(:tennis1_2).id, timeslots.first['id']
          assert_equal 1, timeslots.first['facility_id']
        end

        it 'should accept parameters for TimeslotSearchService' do
          request_params = {
            facility_type: :tennis,
            date_from: DateTime.now.strftime('%Y-%m-%d'),
            date_to: DateTime.now.strftime('%Y-%m-%d'),
            time_from: 12,
            time_to: 14
          }

          authget '/api/v1/timeslots', params: { search: request_params }

          json = json_body
          pagy = json[0]
          timeslots = json[1]
          assert_response :ok

          assert json.is_a?(Array)

          assert pagy.is_a?(Hash)
          assert_equal %w[vars count items page outset last pages offset from to prev next], pagy.keys

          assert timeslots.is_a?(Array)
          assert 3, timeslots.size # number of fixtures matching provided criteria
          assert_equal %w[id slot_time facility_id created_at updated_at state], timeslots.first.keys
          assert_equal 3, timeslots.first['id']
          assert_equal 1, timeslots.first['facility_id']
        end
      end
    end
  end
end
