require 'rails'
if ::Rails.version >= "3.1"
  module Cloudify
    class InstallGenerator < Rails::Generators::Base
      desc "This generator installs the files needed for Cloudify configuration"
      class_option :use_yml, :type => :boolean, :default => false, :desc => "Use YML file instead of Rails Initializer"
      source_root File.expand_path(File.join(File.dirname(__FILE__), '../templates'))

      def app_name
        @app_name ||= Rails.application.is_a?(Rails::Application) && Rails.application.class.name.sub(/::Application$/, "").downcase
      end

      def generate_initializer
        unless options[:use_yml]
          template "cloudify.rb", "config/initializers/cloudify.rb"
        end
      end
    end
  end
end
