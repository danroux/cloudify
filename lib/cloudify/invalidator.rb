module Cloudify
  class Invalidator
    include ActiveModel::Validations

    validates_presence_of :distribution_id
    attr_accessor         :distribution_id
    def initialize
      @invalidator = Fog::CDN.new(Cloudify.config.credentials) if Cloudify.config.valid? && !Cloudify.config.distribution_id.blank?
    end

    def paths
      @paths ||= []
    end

    def << path
      raise ArgumentError unless path.kind_of? String
      paths.include?(path) ? paths : paths << path
    end

    def fog
      @invalidator
    end

    def distribution_id
      Cloudify.config.distribution_id
    end

    def invalidate_paths
      return if !self.valid? || !paths.any?
      STDERR.puts "Invalidating paths: #{paths.join(", ")}"
      fog.purge_from_cdn distribution_id, paths.first
      #fog.post_invalidation(distribution_id, paths).tap do |response|
      #  puts " - Invalidation Id: #{response.body['Id']}\n"
      #end
    end

    private
    def invalidation_method
      case fog
        when Fog::CDN::AWS::Real
          :post_invalidation
        when Fog::CDN::Rackspace::Real
          :purge_from_cdn
      end
    end
  end
end
