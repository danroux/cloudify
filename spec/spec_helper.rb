require "rubygems"
require "rspec"
require "mocha"
require "rails"
require "fog"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "cloud_storage_sync"

Rails.env = "test"
