require 'test_helper'

module Api
  module V1
    class BookingsControllerTest < ActionDispatch::IntegrationTest
      describe '#index' do
        it 'should return unauthorized without user' do
          get '/api/v1/bookings'

          assert_response :unauthorized
        end

        it 'should return all bookings for current_user' do
          authget '/api/v1/bookings'

          json = json_body
          pagy = json[0]
          bookings = json[1]
          assert_response :ok

          assert json.is_a?(Array)

          assert pagy.is_a?(Hash)
          assert_equal %w[vars count items page outset last pages offset from to prev next], pagy.keys

          assert timeslots.is_a?(Array)
          assert Booking.where(user_id: users(:dave).id).count, bookings.size
          assert_equal %w[id timeslot_id user_id state created_at updated_at error_messages notes], bookings.first.keys
          assert_equal bookings(:dave_tennis).id, bookings.first['id']
          assert_equal timeslots(:tennis1_1).id, bookings.first['timeslot_id']
          assert_equal 'booked', bookings.first['state']

          assert(bookings.all? { |booking| booking['user_id'] == users(:dave).id })
        end
      end

      describe '#create' do
        it 'should create a booking with valid data' do
          ts = timeslots(:tennis1_5)

          authpost '/api/v1/bookings', params: { booking: { timeslot_id: ts.id } }

          json = json_body

          assert_not_nil json['id']
          assert_equal ts.id, json['timeslot_id']
          assert_equal users(:dave).id, json['user_id']
          assert_equal 'booked', json['state']
          assert_nil json['error_messages']

          assert Booking.exists?(json['id'])
        end

        it 'should not create a booking with invalid data' do
          authpost '/api/v1/bookings', params: { booking: { timeslot_id: -1 } }

          json = json_body

          assert_nil json['id']
          assert_equal(-1, json['timeslot_id'])
          assert_equal users(:dave).id, json['user_id']
          assert_equal 'unconfirmed', json['state']
          assert_not_nil json['error_messages']

          errors = json['error_messages'].join
          assert_match(/must exist/, errors)
          assert_match(/be blank/, errors)
          assert_match(/is unavailable/, errors)
        end

        it 'should not create a double booking for a timeslot' do
          existing_booking = bookings(:ben_football)

          authpost '/api/v1/bookings', params: { booking: { timeslot_id: existing_booking.timeslot_id } }

          json = json_body

          assert_nil json['id']
          assert_equal(existing_booking.timeslot_id, json['timeslot_id'])
          assert_equal users(:dave).id, json['user_id']
          assert_equal 'unconfirmed', json['state']
          assert_not_nil json['error_messages']

          errors = json['error_messages'].join
          assert_match(/is unavailable/, errors)
        end
      end

      describe '#destroy' do
        it 'should cancel a valid booking' do
          booking = bookings(:dave_tennis)

          authdelete "/api/v1/bookings/#{booking.id}"

          json = json_body

          assert_equal booking.id, json['id']
          assert_equal(booking.timeslot_id, json['timeslot_id'])
          assert_equal users(:dave).id, json['user_id']
          assert_equal 'cancelled', json['state']
          assert_nil json['error_messages']

          assert Timeslot.find(booking.timeslot_id).available?
        end

        it 'should not cancel another user booking' do
          existing_booking = bookings(:ben_football)

          authdelete "/api/v1/bookings/#{existing_booking.id}"

          assert_equal({ 'error' => 'not_found' }, json_body)
          assert(Booking.find(existing_booking.id).booked?)
          assert(Timeslot.find(existing_booking.timeslot_id).unavailable?)
        end

        it 'should return error if no booking exists' do
          authdelete '/api/v1/bookings/-1'

          assert_equal({ 'error' => 'not_found' }, json_body)
        end
      end

      describe '#update' do
        it 'should update valid booking with valid note' do
          booking = bookings(:dave_tennis)

          authpatch "/api/v1/bookings/#{booking.id}", params: { booking: { notes: 'play tennis' } }

          json = json_body

          assert_equal booking.id, json['id']
          assert_equal users(:dave).id, json['user_id']
          assert_equal 'booked', json['state']
          assert_nil json['error_messages']
          assert_equal 'play tennis', json['notes']
        end

        it 'should not update booking for another user' do
          booking = bookings(:ben_football)

          authpatch "/api/v1/bookings/#{booking.id}", params: { booking: { notes: 'play tennis' } }

          assert_equal({ 'error' => 'not_found' }, json_body)

          assert_nil(Booking.find(booking.id).notes)
        end
      end
    end
  end
end
