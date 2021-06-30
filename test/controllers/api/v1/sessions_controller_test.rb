require 'test_helper'

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      describe '#create' do
        it 'should return user with api token with valid credentials' do
          user = users(:dave)
          user.update(api_token: '')

          post '/api/v1/sessions', params: { email: user.email, password: 'Pass123' }

          json = json_body

          assert_response :ok
          assert_equal user.email, json['email']
          refute json['api_token'].blank?
        end

        it 'should return unauthorized with unknown user' do
          post '/api/v1/sessions', params: { email: 'unknown@localhost', password: 'Pass123' }

          json = json_body

          assert_response :unauthorized
          assert_equal({ 'error' => 'unauthorized' }, json)
        end

        it 'should return unauthorized with invalid password' do
          user = users(:dave)

          post '/api/v1/sessions', params: { email: user.email, password: 'bad_password' }

          json = json_body

          assert_response :unauthorized
          assert_equal({ 'error' => 'unauthorized' }, json)
        end
      end
    end
  end
end
