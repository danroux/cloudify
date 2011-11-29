require File.dirname(__FILE__) + '/spec_helper'

describe Cloudify::Invalidator do
context "AWS" do
  before :each do
    Cloudify.instance_variable_set("@invalidator", nil)
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

  it{ should respond_to(:distribution_id) }

  it "should_not be_valid" do
    should_not be_valid
    subject.fog.should be_nil
    expect{ Cloudify.sync }.should_not raise_error
  end

  it "Uploads a new file, deletes it and then creates an invalidation" do
    @config.distribution_id     = "E15MB6BG83O04N"
    should be_valid
    subject.fog.should_not be_nil
    @storage.stub(:local_files).and_return([YML_DIGEST])
    Dir.stub(:glob).and_return([YML_FILE_PATH])
    Cloudify.sync
    @storage.stub(:local_files).and_return([])
    @storage.stub(:remote_files).and_return([YML_DIGEST])
    response = mock(Excon::Response, :body => { "Id" => "hello" })
    Fog::CDN::AWS::Mock.any_instance.should_receive(:post_invalidation).and_return(response)
    Cloudify.sync
    @storage.options[:force_deletion_sync] = true
    Cloudify.invalidator.paths.length.should == 1
  end
end

  context "Rackspace" do
    before do
      Cloudify.instance_variable_set("@invalidator", nil)
      Cloudify.config.credentials.clear
      Cloudify.configure do |config|
        config.provider              = "rackspace"
        config.rackspace_username    = "rackspace_username"
        config.rackspace_api_key     = "rackspace_api_key"
      end

      @config = Cloudify.config

      Fog.mock!
      # create a connection
      connection = Fog::Storage.new(@config.credentials)
    end

    it "should do something" do
      Cloudify.sync
    end
  end  
end

