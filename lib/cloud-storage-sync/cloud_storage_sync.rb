module CloudStorageSync

  class << self

    def config
      @config ||= Config.new
    end

    def configure(&proc)
      yield @config ||= Config.new
    end

    def storage
      @storage ||= Storage.new(config.credentials, config.options)
    end

    def sync
      config.validate
      if config && config.valid?
        storage.sync
      else
        "CloudStorageSync: Something went wrong"
      end
    end
  end
end
