namespace :cloud_storage_sync do
  desc "version"
  task :version do
    puts CloudStorageSync::VERSION
  end
end
         