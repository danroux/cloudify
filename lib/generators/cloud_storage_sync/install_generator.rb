require 'rails/generators'
module CloudStorageSync
  class InstallGenerator < Rails::Generators::Base
    desc "Install a config/cloud_storage_sync.yml and the rake task enhancer"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def app_name
      @app_name ||= Rails.application.is_a?(Rails::Application) && 
        Rails.application.class.name.sub(/::Application$/, "").downcase
    end

    def generate_config
      template "cloud_storage_sync.yml", "config/cloud_storage_sync.yml"
    end

    def generate_rake_task
      template "cloud_storage_sync.rake", "lib/tasks/cloud_storage_sync.rake"
    end
  end
end