module CloudStorageSync

  class << self

    def config
      @config ||= Config.new
    end

    def configure(&proc)
      @config ||= Config.new
      yield @config
    end

    def storage
      @storage ||= Storage.new(config)
    end

    def sync
      raise Config::Invalid.new(config.errors.full_messages.join(', ')) unless config && config.valid?
      storage.sync
    end

  end

end