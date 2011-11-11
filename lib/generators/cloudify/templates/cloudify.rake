Rake::Task["cloud_storage_sync:sync"].enhance do
  Cloudify.sync
end