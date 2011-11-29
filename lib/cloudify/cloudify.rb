module Cloudify

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

    def invalidator
      @invalidator ||= Invalidator.new
    end

    def sync
      if config && config.valid?
        invalidator
        storage.sync
        invalidator.invalidate_paths
      elsif config && !config.valid?
        STDERR.puts "Cloudify: #{config.errors.full_messages.join(', ')}"
      else
        "Cloudify: Something went wrong."
      end
    end
  end
end
