Cloudify.configure do |config|
  ## Cloudify supports the following providers: aws, google, ninefold and rackspace
  ## For more information on which parameters are required for each provider, visit http://fog.io/1.0.0/storage/
  ## Provider examples:
    
  # config.provider              = aws
  # config.aws_access_key_id     = AWS_SECRET_ACCESS_KEY
  # config.aws_secret_access_key = AWS_ACCESS_KEY_ID
  # all other configuration attributes are: endpoint, region, host, path, port, scheme, persistent

  # config.provider              = rackspace  
  # config.rackspace_username    = RACKSPACE_USERNAME
  # config.rackspace_api_key     = RACKSPACE_API_KEY
  ## If you work with the European cloud from Rackspace uncomment the following
  # config.rackspace_european_cloud =  true
  # all other configuration attributes are: rackspace_auth_url, rackspace_servicenet, rackspace_cdn_ssl, persistent

  # config.provider                         = google  
  # config.google_storage_access_key_id     = GOOGLE_STORAGE_ACCESS_KEY_ID
  # config.google_storage_secret_access_key = GOOGLE_STORAGE_SECRET_ACCESS_KEY
  # all other configuration attributes are: host, port, scheme, persistent

  config.aws_access_key_id     = 'AWS_SECRET_ACCESS_KEY'
  config.aws_secret_access_key = 'AWS_ACCESS_KEY_ID'

  # 'assets_directory' aka bucket in aws, container in rackspace, etc.
  config.assets_directory = 'ASSETS_DIRECTORY'

  # Change this to true if you want to delete files that don't exist locally anymore.
  config.force_deletion_sync = false

  # If you have enabled CloudFront on your S3 account or the CDN on Rackspace, 
  # specify the distrubition_id(S3) or the domain( Rackspace) from which you would like to invalidate paths.
  # with the following attribute.
  # config.distribution_id     = "xxxxxxxx"
end
