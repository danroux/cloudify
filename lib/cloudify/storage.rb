module Cloudify
  class Storage

    class BucketNotFound < StandardError; end

    attr_accessor :credentials, :options

    def initialize(credentials, options)
      self.credentials = credentials
      self.options = options
    end

    def connection
      @connection ||= Fog::Storage.new(credentials)
    end

    def bucket
      @bucket ||= connection.directories.get(options[:assets_directory])
      raise BucketNotFound.new("Directory '#{options[:assets_directory]}' not found") unless @bucket
      @bucket
    end

    def force_deletion_sync?
      options[:force_deletion_sync] == true
    end

    def local_files
      @local_files ||= Dir.glob("#{Rails.root.to_s}/public/**/*").map do |f|         
        Digest::MD5.hexdigest(File.read(f)) unless File.directory?(f)
      end
    end
    
    def remote_files
      @remote_files ||= bucket.files.reload.map{ |f| f.etag }
    end

    def files_to_delete
      @files_to_delete ||= (local_files | remote_files) - (local_files & remote_files)
    end

    def upload_new_and_changed_files
      STDERR.puts "Uploading new and changed files"
      Dir.glob("public/**/*").each do |file|
        if File.file?(file)
          remote_file = file.gsub("public/", "")
          obj = bucket.files.head(remote_file)
          get_file = File.open(file)
          if !obj || (obj.etag != Digest::MD5.hexdigest(get_file.read))
            STDERR.print "U " + file
            Cloudify.invalidator << "/#{obj.key}" if obj
            f = bucket.files.create(:key => remote_file, :body => get_file, :public => true, :expires => Time.now)
            STDERR.puts " (" + f.etag + ")"
          end
        end
      end
    end

    def delete_unsynced_remote_files
      STDERR.puts "Deleting remote files that no longer exist locally"
      bucket.files.each do |f|
        if files_to_delete.include?(f.etag)
          STDERR.puts "D #{f.key}"
          f.destroy
        end
      end
    end

    def sync
      upload_new_and_changed_files
      delete_unsynced_remote_files if options[:force_deletion_sync] == true
      STDERR.puts "Done"
    end
  end
end
