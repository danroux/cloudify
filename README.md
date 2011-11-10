# Cloud Storage Sync

Synchronises files between your Rails application and your favorite CDN provider.

Currently supported providers:

* Amazon s3
* Rackspace Cloud Files
* Google Storage

## Installation instructions
The first thing you should do is install the gem.

   gem install cloud-storage-sync

Now, to tell the gem your configuration options you need to do it through the initializer. The gem offers a rails generator to create this initializer which includes documentation on how to use it and what parameters are needed for each of the services currently supported.

The generator creates the file {config/initializers/cloud_storage_sync.rb}[http://github.com/tractical/cloud-storage-sync](example) and you run it like this:

    rails generate cloud_storage_sync:install

### Sync assets

When you're ready to send your files to the cloud all you have to do is to run the following rake task:

    rake cloud_storage_sync:sync_assets

If everything goes well you will see an output similar to this:

    *** Syncing with aws ***
    Uploading new and changed files
    U public/hello.png (b55b17cc47783139c3f5dee0f3a90ce7)
    Done

If you have config.force_deletion_sync set to true, you would get an output like this:

    *** Syncing with aws ***
    Deleting remote files that no longer exist locally
    D Screen shot 2011-11-03 at 12.47.03 PM.png
    D delete_me.png
    ...
    Done


