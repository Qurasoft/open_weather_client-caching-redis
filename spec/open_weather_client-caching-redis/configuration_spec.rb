# frozen_string_literal: true

class RailsTest
  class OpenWeatherClient
    def self.redis!; end

    def self.[](_index)
      {}
    end
  end

  class Credentials
    def self.open_weather_client!
      RailsTest::OpenWeatherClient
    end
  end

  class Application
    def self.credentials
      RailsTest::Credentials
    end
  end

  def self.application
    RailsTest::Application
  end
end

RSpec.describe OpenWeatherClient::Configuration do
  subject { OpenWeatherClient.configuration }

  it 'extends the base configuration' do
    is_expected.to have_attributes(appid: nil)
  end

  it 'has a default configuration' do
    is_expected.to have_attributes(db: nil)
    is_expected.to have_attributes(host: nil)
    is_expected.to have_attributes(password: nil)
    is_expected.to have_attributes(port: nil)
    is_expected.to have_attributes(ttl: 7)
  end

  context 'rails credentials' do
    it 'raises an error if Rails is not available' do
      expect { subject.load_from_rails_credentials }.to raise_error RuntimeError
    end

    context 'available' do
      let(:db) { 0 }
      let(:host) { 'redis.local' }
      let(:password) { 'password!' }
      let(:port) { 6379 }

      it 'loads redis config from credentials' do
        stub_const 'Rails', RailsTest
        allow(Rails.application.credentials.open_weather_client!).to receive(:'redis!').and_return({
                                                                                                     db: db,
                                                                                                     host: host,
                                                                                                     password: password,
                                                                                                     port: port
                                                                                                   })
        subject.load_from_rails_credentials

        is_expected.to have_attributes(db: db)
        is_expected.to have_attributes(host: host)
        is_expected.to have_attributes(password: password)
        is_expected.to have_attributes(port: port)
      end
    end
  end
end
