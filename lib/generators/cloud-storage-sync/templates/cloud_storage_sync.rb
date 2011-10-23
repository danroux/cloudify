CloudStorageSync.configure do |config|
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.aws_bucket = ENV['AWS_BUCKET']
  # config.aws_region = "eu-west-1"
  
  config.rackspace_username = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key = ENV['RACKSPACE_API_KEY']
  config.rackspace_container = ENV['RACKSPACE_CONTAINER']  
  
  config.existing_remote_files = "keep"
end
