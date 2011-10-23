require File.dirname(__FILE__) + '/spec_helper'

describe CloudStorageSync, 'from yml' do

  YML_PATH = File.join(File.dirname(__FILE__), 'fixtures')

  before(:all) do
    @config = CloudStorageSync::Config.new(YML_PATH)
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

  it "loads aws configuration" do
    @storage.credentials.should_not be_nil
    @storage.credentials[:aws_secret_access_key].should_not be_nil
    @storage.credentials[:aws_access_key_id].should_not be_nil
  end
  
  it "loads buckets" do
    @storage.bucket.should_not be_nil
  end

end