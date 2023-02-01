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
    is_expected.to have_attributes(db: 0)
    is_expected.to have_attributes(host: 'localhost')
    is_expected.to have_attributes(password: nil)
    is_expected.to have_attributes(port: 6379)
    is_expected.to have_attributes(ttl: 7)
  end

  context 'rails credentials' do
    it 'raises an error if Rails is not available' do
      expect { subject.load_from_rails_credentials }.to raise_error RuntimeError
    end

    context 'available' do
      before :each do
        stub_const 'Rails', RailsTest
        allow(Rails.application.credentials.open_weather_client!).to receive(:'[]').with(:appid).and_return('123456')
      end

      let(:db) { 0 }
      let(:host) { 'redis.local' }
      let(:password) { 'password!' }
      let(:port) { 6379 }

      it 'loads redis config from credentials' do
        allow(Rails.application.credentials.open_weather_client!)
          .to receive(:'[]').with(:redis).and_return({
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

      it 'raises key error if configuration is empty' do
        allow(Rails.application.credentials.open_weather_client!)
          .to receive(:'[]').with(:redis).and_return(nil)

        expect { subject.load_from_rails_credentials }.to raise_error KeyError
      end
    end
  end
end
