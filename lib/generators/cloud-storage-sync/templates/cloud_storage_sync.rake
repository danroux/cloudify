Rake::Task["cloud_storage_sync:sync"].enhance do
  CloudStorageSync.sync
end