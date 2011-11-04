CloudStorageSync.configure do |config|
  ## Provider examples:
    
  # provider: aws
  # config.aws_access_key_id     = AWS_SECRET_ACCESS_KEY
  # config.aws_secret_access_key = AWS_ACCESS_KEY_ID
  # provider: rackspace  
  # config.rackspace_username = RACKSPACE_USERNAME
  # config.rackspace_api_key  = RACKSPACE_API_KEY
  ## If you work with the European cloud from Rackspace uncomment the following
  # config.rackspace_european_cloud =  true

  # provider: google  
  # config.google_storage_access_key_id     = GOOGLE_STORAGE_ACCESS_KEY_ID
  # config.google_storage_secret_access_key = GOOGLE_STORAGE_SECRET_ACCESS_KEY

  ## CloudStorageSync supports the following providers: aws, google, ninefold and rackspace
  ## For more information on which parameters are required for each provider, visit http://fog.io/1.0.0/storage/
  config.aws_access_key_id     = 'AWS_SECRET_ACCESS_KEY'
  config.aws_secret_access_key = 'AWS_ACCESS_KEY_ID'

  # 'assets_directory' aka bucket in aws, container in rackspace, etc.
  config.assets_directory = 'ASSETS_DIRECTORY'

  config.force_deletion_sync = false
end
