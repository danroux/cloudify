#require 'fog'
require 'active_model'
require 'erb'
require "cloudify/cloudify"
require 'cloudify/config'
require 'cloudify/storage'
require "cloudify/invalidator"
require "cloudify/progress_bar"

module Cloudify
  require 'cloudify/railtie' if defined?(Rails)
end
  
