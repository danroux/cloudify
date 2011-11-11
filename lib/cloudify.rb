require 'fog'
require 'active_model'
require 'erb'
require "cloudify/cloudify"
require 'cloudify/config'
require 'cloudify/storage'

module Cloudify
  require 'cloudify/railtie' if defined?(Rails)
end
# require 'cloudify/engine'  if defined?(Rails)
