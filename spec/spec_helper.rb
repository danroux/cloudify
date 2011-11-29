require "rubygems"
require "rspec"
require "mocha"
require "rails"
require "fog"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "cloudify"

Rails.env = "test"

YML_FILE_PATH = File.join(File.dirname(__FILE__), 'fixtures', "cloudify.yml")
YML_FILE = File.read(YML_FILE_PATH)
YML_DIGEST = Digest::MD5.hexdigest(YML_FILE)

