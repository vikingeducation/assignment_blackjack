guard :rspec, cmd: 'bundle exec rspec' do
  watch(//)                     { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^models/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^helpers/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end