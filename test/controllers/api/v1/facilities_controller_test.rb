require 'test_helper'

module Api
  module V1
    class FacilitiesControllerTest < ActionDispatch::IntegrationTest
      describe '#index' do
        it 'should return unauthorized without user' do
          get '/api/v1/facilities'

          assert_response :unauthorized
        end

        it 'should return all facilities' do
          authget '/api/v1/facilities'

          json = json_body
          pagy = json[0]
          facilities = json[1]
          assert_response :ok

          assert json.is_a?(Array)

          assert pagy.is_a?(Hash)
          assert_equal %w[vars count items page outset last pages offset from to prev next], pagy.keys

          assert facilities.is_a?(Array)
          assert Facility::Base.count, facilities.size
          assert_equal %w[id name metadata created_at updated_at type], facilities.first.keys
          assert_equal 1, facilities.first['id']
          assert_equal 'Tennis Court One', facilities.first['name']
          assert_equal 'Facility::Tennis', facilities.first['type']
        end
      end
    end
  end
end
