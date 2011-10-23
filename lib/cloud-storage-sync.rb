require 'fog'
require 'active_model'
require 'erb'
require "cloud-storage-sync/cloud-storage-sync"
require 'cloud-storage-sync/config'
require 'cloud-storage-sync/storage'


require 'cloud-storage-sync/railtie' if defined?(Rails)
require 'cloud-storage-sync/engine'  if defined?(Rails)

## 

require 'rubygems'
require 'fog'
require 'digest/md5'
require 'mime/types'
require 'ruby-debug'

storage = Fog::Storage.new({
  :aws_access_key_id      => 'AKIAJHNPUUH5M6JQZHPQ',
  :aws_secret_access_key  => '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',
  :provider               => 'AWS'
})

directory = storage.directories.get('test.tractical.com')

bucket = directory

STDOUT.sync = true

Dir.glob("public/**/*").each do |file|

  ## Only upload files, we're not interested in directories
  if File.file?(file)

    ## Slash 'public/' from the filename for use on S3
    remote_file = file.gsub("public/", "")

    ## Try to find the remote_file, an error is thrown when no
    ## such file can be found, that's okay.
    begin
      obj = bucket.files.get(remote_file)
    rescue
      obj = nil
    end

    ## If the object does not exist, or if the MD5 Hash / etag of the 
    ## file has changed, upload it.
        
    if !obj || (obj.etag != Digest::MD5.hexdigest(File.read(file)))
      print "U "
      print file + " "
      
      if obj
        print obj.etag + " .. "
      end
        
      ## fog create file
      f = directory.files.create(
        :key    => remote_file,
        :body   => File.open(file),
        :public => true
      )
    
      puts f.etag

    else
      puts ". " + obj.key + " " + obj.etag + " " + obj.public_url
    end
  end
end
puts ""

STDOUT.sync = false # Done with progress output.

