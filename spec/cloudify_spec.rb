require File.dirname(__FILE__) + '/spec_helper'

describe Cloudify::Config  do
  it "should have each DYNAMIC_SERVICES accessor for configuration" do
    Cloudify::Config::DYNAMIC_SERVICES.each do |service_config|
      should respond_to(service_config)
    end
  end
end

describe Cloudify do
  before(:each) do
    @config = Cloudify.config
  end

  context "invalid configuration" do
    context "missing required files" do
      it "should not be valid when google" do
        @config.provider = "google"
        @config.should_not be_valid
        @config.errors[:provider].should be_empty
        @config.errors[:google_storage_access_key_id].should_not be_empty
        @config.errors[:google_storage_secret_access_key].should_not be_empty
      end

      it "should not be valid when aws" do
        @config.provider = "aws"
        @config.should_not be_valid
        @config.errors[:provider].should be_empty
        @config.errors[:aws_secret_access_key].should_not be_empty
        @config.errors[:aws_access_key_id].should_not be_empty
      end

      it "should not be valid when rackspace" do
        @config.provider = "rackspace"
        @config.should_not be_valid
        @config.errors[:provider].should be_empty
        @config.errors[:rackspace_username].should_not be_empty
        @config.errors[:rackspace_api_key].should_not be_empty
      end

      it "should not be valid when ninefold" do
        @config.provider = "ninefold"
        @config.should_not be_valid
        @config.errors[:provider].should be_empty
        @config.errors[:ninefold_storage_token].should_not be_empty
        @config.errors[:ninefold_storage_secret].should_not be_empty
      end

      it "should not be valid with wrong provider" do
        @config.provider = "donotexist"
        @config.should_not be_valid
        @config.errors[:provider].should_not be_empty
      end

      it "should not be valid without assets_directory" do
        @config.should_not be_valid
        @config.errors[:assets_directory].should_not be_empty
      end
    end
  end
end

describe Cloudify, 'with #configure(initializer)' do
  before(:all) do
    Cloudify.configure do |config|
      config.provider = "aws"
      config.aws_secret_access_key = "111222333444"
      config.aws_access_key_id     = "qwerty1234567890"
      config.assets_directory      = "app_test"
    end

    @config = Cloudify.config

    Fog.mock!
    # create a connection
    connection = Fog::Storage.new(@config.credentials)
    # First, a place to contain the glorious details
    connection.directories.create(
      :key    => @config.options[:assets_directory],
      :public => true
    )

    @storage = Cloudify.storage
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
    expect{ Cloudify.sync }.should_not raise_error
  end

  context "Connect to each service supported" do
    before(:each) do
      @config.credentials.clear
    end

    it "syncs to google" do
      Cloudify.configure do |config|
        config.provider = "google"
        config.google_storage_access_key_id = "somegooglekey"
        config.google_storage_secret_access_key = "secret_access_key"
        config.persistent = true
      end
     
      expect{ @connection = create_connection }.not_to raise_error
      @connection.should be_a_kind_of Fog::Storage::Google::Mock
    end

    it "syncs to aws" do
      Cloudify.configure do |config|
        config.provider = "aws"
        config.aws_access_key_id  = "api_key"
        config.aws_secret_access_key = "username"
      end
     
      expect{ @connection = create_connection }.not_to raise_error
      @connection.should be_a_kind_of Fog::Storage::AWS::Mock
    end

    it "syncs to rackspace" do
      Cloudify.configure do |config|
        config.provider = "rackspace"
        config.rackspace_username = "username"
        config.rackspace_api_key  = "api_key"
      end
     
      expect{ @connection = create_connection }.to raise_error(Fog::Errors::MockNotImplemented, "Contributions welcome!")
    end

    it "syncs to ninefold" do
      Cloudify.configure do |config|
        config.provider = "ninefold"
        config.ninefold_storage_token  = "token_key"
        config.ninefold_storage_secret = "secret"
      end
     
      expect{ @connection = create_connection }.to raise_error(Fog::Errors::MockNotImplemented, "Contributions welcome!")
    end
  end
end

describe Cloudify::Storage do
  YML_FILE_PATH = File.join(File.dirname(__FILE__), 'fixtures', "cloudify.yml")
  YML_FILE = File.read(YML_FILE_PATH)
  YML_DIGEST = Digest::MD5.hexdigest(YML_FILE)

  before do
    config = mock(Cloudify::Config)
    config.stub(:credentials).and_return(:provider              =>"aws", 
                                         :aws_secret_access_key =>"111222333444", 
                                         :aws_access_key_id     =>"qwerty1234567890")

    config.stub(:options).and_return(:assets_directory    => "app_test",
                                     :force_deletion_sync => false)

    Cloudify.stub(:config).and_return(config)
    @config = Cloudify.config
  
    Fog.mock!
    # create a connection
    connection = Fog::Storage.new(@config.credentials)
    # First, a place to contain the glorious details
    connection.directories.create(
      :key    => @config.options[:assets_directory],
      :public => true
    )

    @storage = Cloudify::Storage.new(@config.credentials, @config.options)
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
    @storage.stub(:remote_files).and_return([YML_DIGEST])
    @storage.sync
    @storage.bucket.files.reload
    @storage.bucket.files.length.should == 1
    @storage.options[:force_deletion_sync] = true
    Fog::Storage::AWS::File.any_instance.should_receive(:etag).and_return(YML_DIGEST)
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
