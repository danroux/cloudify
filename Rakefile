require 'bundler/gem_tasks'
require 'ruby-debug'
rakes = Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake"]
rakes.sort.each { |ext| load ext; puts ext }
