require 'rails'
if ::Rails.version >= "3.1"
  module CloudStorageSync
    class InstallGenerator < Rails::Generators::Base
      desc "This generator installs the files needed for CloudStorageSync configuration"
      class_option :use_yml, :type => :boolean, :default => false, :desc => "Use YML file instead of Rails Initializer"
      source_root File.expand_path(File.join(File.dirname(__FILE__), '../templates'))

      def app_name
        @app_name ||= Rails.application.is_a?(Rails::Application) && Rails.application.class.name.sub(/::Application$/, "").downcase
      end

      def generate_yml_config
        if options[:use_yml]
          template "cloud_storage_sync.yml", "config/cloud_storage_sync.yml"
        end
      end

      def generate_initializer
        unless options[:use_yml]
          template "cloud_storage_sync.rb", "config/initializers/cloud_storage_sync.rb"
        end
      end
    end
  end
end
