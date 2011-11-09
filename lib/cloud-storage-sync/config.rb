module CloudStorageSync
  class Config
    include ActiveModel::Validations
    DYNAMIC_SERVICES = [:provider, 
                        :google_storage_secret_access_key, :google_storage_access_key_id,
                        :aws_secret_access_key, :aws_access_key_id, 
                        :rackspace_username,    :rackspace_api_key, :rackspace_european_cloud,
                        :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl,
                        :ninefold_storage_token,:ninefold_storage_secret,
                        :endpoint, :region, :host, :path, :port, :scheme, :persistent]

    class Invalid < StandardError; end

    attr_accessor :provider, :force_deletion_sync, :credentials, :assets_directory, :config_path
    
    validates_presence_of  :assets_directory
    validates_inclusion_of :force_deletion_sync, :in => [true, false]

    def initialize
      self.force_deletion_sync = false
      self.credentials = {}
    end

    def force_deletion_sync?
      self.force_deletion_sync == true
    end

    def initializer_exists?
      path = File.join(config_path, "initializers", "cloud_storage_sync.rb")
      File.exists? path
    end

    def validate
      case provider
      when "aws"
        requires :aws_access_key_id, :aws_secret_access_key
        #recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent
      when "rackspace"
        requires :rackspace_api_key, :rackspace_username
        #recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent
      when "google"
        requires :google_storage_access_key_id, :google_storage_secret_access_key
        #recognizes :host, :port, :scheme, :persistent
      when "ninefold"
        requires :ninefold_storage_token, :ninefold_storage_secret
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end
    
    def requires(*attrs)
      attrs.each do |key|
        raise ArgumentError.new("#{provider.capitalize} requires #{attrs.join(', ')} in configuration files") if self.send(key).nil?
      end
    end
    
    def options
      { :assets_directory => assets_directory, :force_deletion_sync => force_deletion_sync }
    end

    DYNAMIC_SERVICES.each do |key|
      variable = :"@#{key}"
      define_method :"#{key}=" do |value|
        self.credentials.merge!(key => value)
        instance_variable_set variable, value 
      end      

      class_eval "def #{key}; @#{key}; end\n"
    end
  end
end
