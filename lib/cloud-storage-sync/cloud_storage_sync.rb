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
      raise Config::Invalid.new(config.errors.full_messages.join(', ')) unless config && config.valid?
      storage.sync
    end
  end
end
