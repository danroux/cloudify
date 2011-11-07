module CloudStorageSync
  class Railtie < Rails::Railtie
    railtie_name :cloud_storage_sync

    rake_tasks do
      load "tasks/deploy.rake"
    end
  end
end
