module Cloudify
  class InstallGenerator < Rails::Generators::Base
    desc "This generator installs the files needed for Cloudify configuration"

    source_root File.expand_path(File.join(File.dirname(__FILE__), '../templates'))

    def app_name
      @app_name ||= Rails.application.is_a?(Rails::Application) && Rails.application.class.name.sub(/::Application$/, "").downcase
    end

    def generate_initializer
      template "cloudify.rb", "config/initializers/cloudify.rb"
    end

    def show_readme
      readme 'README'
    end 
  end
end
