# A sample Guardfile
# More info at http://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
  watch('^spec/(.*)_spec.rb')
  watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('^spec/spec_helper.rb')                       { "spec" }

  # Rails example
  watch('^app/views/(.*)/.*')                         { |m| "spec/requests/#{m[1]}_request_spec.rb" }
  watch('^app/controllers/(.*)_controller\.rb')       { |m| "spec/requests/#{m[1]}_request_spec.rb" }
  watch('^app/(.*)\.rb')                              { |m| "spec/#{m[1]}_spec.rb" }
  # watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('^config/routes.rb')                          { "spec/routing" }
  watch('^app/controllers/application_controller.rb') { "spec/controllers" }
  watch('^spec/factories.rb')                         { "spec/models" }
end
