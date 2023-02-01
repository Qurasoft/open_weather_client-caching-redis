# frozen_string_literal: true

require 'open_weather_client/configuration'

module OpenWeatherClient
  ##
  # Configuratin of OpenWeatherClient
  class Configuration
    # [Integer] db of the redis server used for caching
    attr_accessor :db
    # [String] host of the redis server
    attr_accessor :host
    # [Integer] password of the redis server
    attr_accessor :password
    # [Integer] port of the redis server
    attr_accessor :port
    # [Integer] The time in days until an entry cached in redis is expired
    attr_accessor :ttl

    alias old_initialize initialize

    def initialize
      old_initialize

      self.db = 0
      self.host = 'localhost'
      self.port = 6379
      self.ttl = 7
    end

    alias old_load load_from_rails_credentials

    def load_from_rails_credentials
      old_load

      settings = Rails.application.credentials.open_weather_client![:redis]
      raise KeyError unless settings

      self.host = settings[:host]
      self.port = settings[:port]
      self.db = settings[:db]
      self.password = settings[:password]
    end
  end
end
