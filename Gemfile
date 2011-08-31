source 'http://rubygems.org'

gem "rails", "3.0.10"
gem "mysql2"
gem "redcarpet"
gem "coderay"
gem "thinking-sphinx", ">= 2.0.1", :require => "thinking_sphinx"
gem "whenever", :require => false
gem "will_paginate", ">= 3.0.pre2"
gem "jquery-rails"
gem "omniauth", ">= 0.2.2"
gem "exception_notification", :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"
gem "ancestry"
gem "cancan", :git => "git://github.com/ryanb/cancan.git", :branch => "2.0"
gem "paper_trail"

group :development, :test do
  gem "rspec-rails"
  gem "launchy"
end

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "guard"
  gem "guard-rspec"
  gem "fakeweb"
  gem "simplecov", :require => false
end

group :development do
  gem "thin"
  gem "nifty-generators"
  gem "capistrano"
end
