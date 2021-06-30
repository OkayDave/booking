ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

def authprocess(meth, path, **args)
  user_sym = args.delete(:user) || :dave
  user = users(user_sym)
  args[:params] ||= {}
  args[:params].merge!({ api_token: user.api_token })

  process(meth, path, **args)
end

def authpost(path, **args)
  authprocess(:post, path, **args)
end

def authget(path, **args)
  authprocess(:get, path, **args)
end

def authpatch(path, **args)
  authprocess(:patch, path, **args)
end

def authdelete(path, **args)
  authprocess(:delete, path, **args)
end

def json_body
  JSON.parse(response.body)
end
