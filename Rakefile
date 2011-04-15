# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

desc "Run tests with coverage"
task :coverage do
  ENV['COVERAGE'] = "true"
  Rake::Task["spec"].execute
  Launchy.open("file://" + File.expand_path("../coverage/index.html", __FILE__))
end

Railscasts::Application.load_tasks
