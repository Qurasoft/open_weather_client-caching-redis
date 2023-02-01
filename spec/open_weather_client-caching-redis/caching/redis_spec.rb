# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Caching::Redis do
  it 'has a version number' do
    expect(OpenWeatherClient::Caching::Redis::VERSION).not_to be nil
  end

  describe '#initialize' do
    before :each do
      allow(::Redis).to receive(:new).and_return(redis)
    end

    let(:redis) { 'redis_instance' }

    it 'creates a redis instance' do
      subject

      expect(::Redis).to have_received(:new).once.with({ host: nil, port: nil, db: nil })
    end

    it 'persists the redis instance' do
      expect(subject).to have_attributes(redis: redis)
    end
  end

  describe '#caching_get' do
    before :each do
      @cache_key = "weather:#{lat}:#{lon}:#{time.strftime('%Y-%m-%dT%H')}"

      allow(subject.redis).to receive(:get).with(@cache_key).and_return('{"key": "value"}')
      allow(subject).to receive('present?').with(@cache_key).and_return(true)
    end

    let(:lat) { 0.5 }
    let(:lon) { 1.0 }
    let(:time) { Time.now }

    it 'parses and returns the stored data' do
      expect(subject.get(lat: lat, lon: lon, time: time)).to match hash_including('key' => 'value')

      expect(subject.redis).to have_received(:get).once.with(@cache_key)
    end
  end

  describe '#caching_store' do
    before :each do
      @cache_key = "weather:#{lat}:#{lon}:#{time.strftime('%Y-%m-%dT%H')}"

      allow(subject.redis).to receive(:set).with(@cache_key, '{"key":"value"}', ex: 604_800).and_return(true)
    end

    let(:data) { { 'key' => 'value' } }
    let(:lat) { 0.5 }
    let(:lon) { 1.0 }
    let(:time) { Time.now }

    it 'formats, stores and expires the data' do
      subject.store(lat: lat, lon: lon, time: time, data: data)

      expect(subject.redis).to have_received(:set).once.with(@cache_key, '{"key":"value"}', ex: 604_800)
    end
  end

  describe '#present?' do
    before :each do
      @cache_key = "weather:#{lat}:#{lon}:#{time.strftime('%Y-%m-%dT%H')}"

      allow(subject.redis).to receive(:exists?).with(@cache_key).and_return(true)
    end

    let(:lat) { 0.5 }
    let(:lon) { 1.0 }
    let(:time) { Time.now }

    it 'checks redis fpr existence' do
      expect(subject.send(:present?, @cache_key)).to eq true

      expect(subject.redis).to have_received(:exists?).once.with(@cache_key)
    end
  end
end
