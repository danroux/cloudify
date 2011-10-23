require File.dirname(__FILE__) + '/spec_helper'

describe CloudStorageSync, 'from yml' do

  YML_PATH = File.join(File.dirname(__FILE__), 'fixtures')

  before(:all) do
    @config  = CloudStorageSync::Config.new(YML_PATH)
    @storage = CloudStorageSync::Storage.new(@config)
  end

  it "loads aws configuration" do
    @config.credentials.should_not be_nil
  end

end