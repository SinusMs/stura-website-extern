ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_admin
      get logout_url
      post login_url, params: { username: "admin", password: "123" }
    end
    def login_user
      get logout_url
      post login_url, params: { username: "user", password: "123" }
    end
  end
end
