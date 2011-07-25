if ENV['COVERAGE']
  require "simplecov"
  SimpleCov.start "rails"
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rspec"

# Capybara.javascript_driver = :webkit

FakeWeb.allow_net_connect = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = {
  'uid' => '12345',
  "user_info" => {
    "email" => "foo@example.com",
    "nickname" => "foobar",
    "name" => "Foo Bar"
  }
}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    FakeWeb.clean_registry
    reset_email
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
    if example.metadata[:js]
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.include AuthMacros
  config.include MailerMacros
end


# quick hack to get Rack to be quiet about "warning: regexp match /.../n against to UTF-8 string" until we upgrade to Rails 3.1 with Rack 1.3
module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end
