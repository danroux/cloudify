require 'rails/generators'
module Cloudify
  class InstallGenerator < Rails::Generators::Base
    desc "Install a config/cloudify.yml and the rake task enhancer"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def app_name
      @app_name ||= Rails.application.is_a?(Rails::Application) && 
        Rails.application.class.name.sub(/::Application$/, "").downcase
    end

    def generate_config
      template "cloudify.yml", "config/cloudify.yml"
    end

    def generate_rake_task
      template "cloudify.rake", "lib/tasks/cloudify.rake"
    end
  end
end