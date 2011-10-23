require 'bundler/gem_tasks'
puts Dir.glob("#{File.dirname(__FILE__)}/lib/tasks/*.rake")
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext; puts ext }

