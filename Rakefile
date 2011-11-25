require 'rake/testtask'
require 'rspec/core/rake_task'
# Use Rakefile for tasks that operate on the plugin’s source files, such as special testing or documentation. 
# These must be run from the plugin’s directory.

# rakes = Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake"]
# rakes.sort.each { |ext| load ext; puts ext }
Bundler::GemHelper.install_tasks

task :default => :test

desc 'Run ALL OF the specs'
RSpec::Core::RakeTask.new(:spec)

desc "Run Cloudify generator tests."
Rake::TestTask.new(:test_unit)do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :test => [ :test_unit, :spec ]