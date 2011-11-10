require 'fog'
require 'active_model'
require 'erb'
require "cloud-storage-sync/cloud_storage_sync"
require 'cloud-storage-sync/config'
require 'cloud-storage-sync/storage'

module CloudStorageSync
  require 'cloud-storage-sync/railtie' if defined?(Rails)
end
# require 'cloud-storage-sync/engine'  if defined?(Rails)
