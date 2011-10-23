CloudStorageSync.configure do |config|
  config.aws_secret_access_key = 'AWS_SECRET_ACCESS_KEY'
  config.aws_access_key_id = 'AWS_ACCESS_KEY_ID'

  # 'assets_directory' aka bucket in aws, container in rackspace, etc.
  config.assets_directory = 'ASSETS_DIRECTORY'

  config.force_deletion_sync = false
end
