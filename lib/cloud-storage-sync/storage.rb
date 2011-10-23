module CloudStorageSync
  class Storage

    class BucketNotFound < StandardError; end

    attr_accessor :config

    def initialize(config)
      self.config = config
    end

    def connection
      @connection ||= Fog::Storage.new(config.credentials)
    end

    def bucket
      @bucket ||= connection.directories.get(config.assets_directory)
      raise BucketNotFound.new("Directory '#{config.assets_directory}' not found") unless @bucket
      @bucket
    end

    def force_deletion_sync?
      self.config.force_deletion_sync?
    end
    
    def local_files
      Dir.glob("#{Rails.root.to_s}/public/**/*").map{|f| Digest::MD5.hexdigest(File.read(f)) }
    end
    
    def remote_files
      bucket.files.map{ |f| f.etag }
    end

    def upload_new_and_changed_files
      STDERR.puts "Uploading new and changed files"
      Dir.glob("public/**/*").each do |file|
        if File.file?(file)
          remote_file = file.gsub("public/", "")
          begin
            obj = bucket.files.get(remote_file)
          rescue
            obj = nil
          end
          if !obj || (obj.etag != Digest::MD5.hexdigest(File.read(file)))
            STDERR.print "U " + file
            f = bucket.files.create(:key => remote_file, :body => File.open(file), :public => true)
            STDERR.puts " (" + f.etag + ")"
          end
        end
      end
    end

    def delete_unsynced_remote_files
      STDERR.puts "Deleting remote files that no longer exist locally"
      files_to_delete = (local_files | remote_files) - (local_files & remote_files)
      bucket.files.each do |f|
        if files_to_delete.include?(f.key)
          STDERR.puts "D #{f.key}"
          # f.destroy
        end
      end
    end

    def sync
      upload_new_and_changed_files
      delete_unsynced_remote_files if force_deletion_sync?
      STDERR.puts "Done"
    end

  end
end