require File.dirname(__FILE__) + '/spec_helper'

describe CloudStorageSync::Config  do
  it "should have each DYNAMIC_SERVICES accessor for configuration" do
    CloudStorageSync::Config::DYNAMIC_SERVICES.each do |service_config|
      should respond_to(service_config)
    end
  end
end

describe CloudStorageSync, 'with #configure(initializer)' do
  before(:all) do
    CloudStorageSync.configure do |config|
      config.provider = "aws"
      config.aws_secret_access_key = "111222333444"
      config.aws_access_key_id     = "qwerty1234567890"
      config.assets_directory      = "app_test"
    end

    @config = CloudStorageSync.config

    Fog.mock!
    # create a connection
    connection = Fog::Storage.new(@config.credentials)
    # First, a place to contain the glorious details
    connection.directories.create(
      :key    => @config.options[:assets_directory],
      :public => true
    )

    @storage = CloudStorageSync.storage
  end

  it "loads aws configuration" do
    @storage.credentials.should eq(@config.credentials)
    @storage.credentials[:provider].should              == "aws"
    @storage.credentials[:aws_secret_access_key].should == "111222333444"
    @storage.credentials[:aws_access_key_id].should     == "qwerty1234567890"
  end
  
  it "loads buckets" do
    @storage.bucket.should_not be_nil
  end

  it "syncs to aws" do
    expect{ CloudStorageSync.sync }.should_not raise_error
  end

  it "requires valid configuration fields" do
    CloudStorageSync.config.provider = "rackspace"
    expect{ CloudStorageSync.sync}.to raise_error(ArgumentError, 
                                                  "Rackspace requires rackspace_api_key, rackspace_username in configuration files")
    CloudStorageSync.config.provider = "google"
    expect{ CloudStorageSync.sync}.to raise_error(ArgumentError, 
                                                  "Google requires google_storage_access_key_id, google_storage_secret_access_key in configuration files")
    CloudStorageSync.config.provider = "ninefold"
    expect{ CloudStorageSync.sync}.to raise_error(ArgumentError, 
                                                  "Ninefold requires ninefold_storage_token, ninefold_storage_secret in configuration files")
    CloudStorageSync.config.provider = "best_cloud_service"
    expect{ CloudStorageSync.sync}.to raise_error(ArgumentError, 
                                                  "best_cloud_service is not a recognized storage provider")
  end

  context "Connect to each service supported" do
    before(:each) do
      @config.credentials.clear
    end

    it "syncs to google" do
      CloudStorageSync.configure do |config|
        config.provider = "google"
        config.google_storage_access_key_id = "somegooglekey"
        config.google_storage_secret_access_key = "secret_access_key"
        config.persistent = true
      end
     
      expect{ @connection = create_connection }.not_to raise_error
      @connection.should be_a_kind_of Fog::Storage::Google::Mock
    end

    it "syncs to aws" do
      CloudStorageSync.configure do |config|
        config.provider = "aws"
        config.aws_access_key_id  = "api_key"
        config.aws_secret_access_key = "username"
      end
     
      expect{ @connection = create_connection }.not_to raise_error
      @connection.should be_a_kind_of Fog::Storage::AWS::Mock
    end

    it "syncs to rackspace" do
      CloudStorageSync.configure do |config|
        config.provider = "rackspace"
        config.rackspace_username = "username"
        config.rackspace_api_key  = "api_key"
      end
     
      expect{ @connection = create_connection }.to raise_error(Fog::Errors::MockNotImplemented, "Contributions welcome!")
    end

    it "syncs to ninefold" do
      CloudStorageSync.configure do |config|
        config.provider = "ninefold"
        config.ninefold_storage_token  = "token_key"
        config.ninefold_storage_secret = "secret"
      end
     
      expect{ @connection = create_connection }.to raise_error(Fog::Errors::MockNotImplemented, "Contributions welcome!")
    end
  end
end

describe CloudStorageSync::Storage do
  YML_FILE_PATH = File.join(File.dirname(__FILE__), 'fixtures', "cloud_storage_sync.yml")
  YML_FILE = File.read(YML_FILE_PATH)
  YML_DIGEST = Digest::MD5.hexdigest(YML_FILE)

  before do
    config = mock(CloudStorageSync::Config)
    config.stub(:credentials).and_return(:provider              =>"aws", 
                                         :aws_secret_access_key =>"111222333444", 
                                         :aws_access_key_id     =>"qwerty1234567890")

    config.stub(:options).and_return(:assets_directory    => "app_test",
                                     :force_deletion_sync => false)

    CloudStorageSync.stub(:config).and_return(config)
    @config = CloudStorageSync.config
  
    Fog.mock!
    # create a connection
    connection = Fog::Storage.new(@config.credentials)
    # First, a place to contain the glorious details
    connection.directories.create(
      :key    => @config.options[:assets_directory],
      :public => true
    )

    @storage = CloudStorageSync::Storage.new(@config.credentials, @config.options)
  end

  it "Uploads a new file and then deletes it" do
    @storage.stub(:local_files).and_return([YML_DIGEST])
    Dir.stub(:glob).and_return([YML_FILE_PATH])
    @storage.local_files.length.should  == 1
    @storage.bucket.files.length.should == 0
    @storage.sync
    @storage.bucket.files.reload
    @storage.bucket.files.length.should == 1
    Dir.stub(:glob).and_return([])
    @storage.stub(:local_files).and_return([])
    @storage.stub(:remote_files).and_return([YML_FILE_PATH])
    @storage.sync
    @storage.bucket.files.reload
    @storage.bucket.files.length.should == 1
    @storage.options[:force_deletion_sync] = true
    @storage.sync
    @storage.bucket.files.reload
    @storage.bucket.files.length.should == 0
  end
end

def create_connection
  connection = Fog::Storage.new(@config.credentials)
  # First, a place to contain the glorious details
  connection.directories.create(:key    => @config.options[:assets_directory],
                                :public => true)
  connection
end
