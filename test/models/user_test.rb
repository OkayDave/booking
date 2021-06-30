require 'test_helper'

class UserTest < ActiveSupport::TestCase
  describe '.find_by_credentials' do
    test 'return correct User when provided valid credentials' do
      assert_equal users(:dave), User.find_by_credentials('dave@localhost', 'Pass123')
    end

    test 'return nil with unknown user' do
      assert_nil User.find_by_credentials('unknown@localhost', 'Pass123')
    end

    test 'return nil with incorrect password' do
      assert_nil User.find_by_credentials('dave@localhost', 'bad_password')
    end
  end

  describe '.find_by_api_token' do
    test 'return nil if provided token is blank' do
      assert_nil User.find_by_api_token nil
      assert_nil User.find_by_api_token ''
    end

    test 'return nil if provided token is incorrect' do
      assert_nil User.find_by_api_token 'incorrect_token'
    end

    test 'return correct User when provided token is correct' do
      assert_equal users(:dave), User.find_by_api_token('token123')
    end
  end

  describe '#api_token' do
    test 'return existing token if present' do
      assert_equal 'token123', users(:dave).api_token
    end

    test 'generate and persist a new token if not present' do
      users(:dave).update(api_token: '')

      assert users(:dave).attributes['api_token'].blank?

      user = users(:dave)

      refute user.api_token.blank?

      user.reload

      refute user.api_token.blank?
    end
  end
end
