module CloudStorageSync
  class Config
    include ActiveModel::Validations

    class Invalid < StandardError; end

    attr_accessor :provider, :force_deletion_sync, :credentials, :assets_directory,
      :config_path
    
    validates_presence_of :assets_directory
    validates_inclusion_of :force_deletion_sync, :in => %w(true false)

    def initialize(config_path=nil)
      self.config_path = config_path || File.join(Rails.root, "config")
      self.force_deletion_sync = false
      self.credentials = {}
      load_yml! if yml_exists?
    end

    def force_deletion_sync?
      self.force_deletion_sync == true
    end

    def yml_exists?
      File.exists?(self.yml_file_path)
    end

    def yml
      y ||= YAML.load(ERB.new(IO.read(self.yml_file_path)).result)[Rails.env] rescue nil || {}
    end

    def yml_file_path
      File.join(self.config_path, 'cloud_storage_sync.yml')
    end

    def load_yml!
      self.assets_directory = yml["assets_directory"]
      self.provider = yml["provider"].downcase
      credentials.merge!(:provider => provider)
      case provider
      when "aws"
        requires :aws_access_key_id, :aws_secret_access_key
        recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent
      when "rackspace"
        requires :rackspace_api_key, :rackspace_username
        recognizes :rackspace_auth_url, :rackspace_servicenet, :rackspace_cdn_ssl, :persistent
      when "google"
        requires :google_storage_access_key_id, :google_storage_secret_access_key
        recognizes :host, :port, :scheme, :persistent
      when "ninefold"
        requires :ninefold_storage_token, :ninefold_storage_secret
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end
    
    def requires(*attrs)
      attrs.each do |key|
        raise ArgumentError.new("#{provider.capitalize} requires #{attrs.join(', ')} in YAML configuration files") if yml[key.to_s].nil?
        credentials.merge!(key => yml[key.to_s])
      end
    end
        
    def recognizes(*attrs)
      attrs.each{|key| credentials.merge!(key => yml[key.to_s])}
    end
    
    def options
      { :assets_directory => assets_directory, :force_deletion_sync => force_deletion_sync }
    end

  end
end