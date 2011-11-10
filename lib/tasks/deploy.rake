namespace :cloud_storage_sync do
  desc "sync assets"
  task :sync_assets => :environment do
    puts "*** Syncing with #{CloudStorageSync.config.provider} ***"
    CloudStorageSync.sync
  end
end
         