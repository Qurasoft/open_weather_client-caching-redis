# frozen_string_literal: true

require 'open_weather_client/caching'
require 'open_weather_client-caching-redis/configuration'
require 'redis'
require_relative 'redis/version'

module OpenWeatherClient
  class Caching
    ##
    # Redis cache of OpenWeatherMap requests
    #
    # The requests are cached in redis with an expiration time set by the configuration
    class Redis < OpenWeatherClient::Caching
      attr_reader :redis

      def initialize
        super

        config = OpenWeatherClient.configuration
        @redis = ::Redis.new(host: config.host, port: config.port, db: config.db)
      end

      private

      def caching_get(key)
        JSON.parse(redis.get(key))
      end

      def caching_store(key, data)
        redis.set key, data.to_json, ex: OpenWeatherClient.configuration.ttl * 24 * 60 * 60

        data
      end

      def present?(key)
        redis.exists?(key)
      end
    end
  end
end
