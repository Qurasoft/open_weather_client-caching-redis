# OpenWeatherClient::Caching::Redis

[![Gem Version](https://badge.fury.io/rb/open_weather_client-caching-redis.svg)](https://badge.fury.io/rb/open_weather_client-caching-redis)
![RSpec](https://github.com/qurasoft/open_weather_client-caching-redis/actions/workflows/ruby.yml/badge.svg)

Welcome to OpenWeatherClient::Caching::Redis.
This gem provides the redis caching method for [OpenWeatherClient](https://github.com/qurasoft/open_waether_client).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_weather_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_weather_client-caching-redis

## Usage

Configure `OpenWeatherClient` to use redis caching.
The redis connection can be configured through rails credentials or by manually setting the parameters in configuration.

```ruby
# OpenWeatherClient initializer
OpenWeatherClient.configure do |config|
  config.caching = OpenWeatherClient::Caching::Redis
  # Time in days until cached requests are expired, default: 7
  config.ttl = 14
  
  # redis connection configuration
  config.db = 0
  config.host = 'localhost'
  config.password = '123456'
  config.port = 6379
end
```

### Secure Configuration

```yaml
# $ bin/rails credentials:edit
open_weather_client:
  appid: "<INSERT OPENWEATHERMAP API KEY HERE>"
  redis:
    db: 0
    host: 'localhost'
    password: '123456'
    port: 6379
```

After configuration of the credentials you can load the settings in your initializer with `#load_from_rails_configuration`.

```ruby
# OpenWeatherClient initializer
OpenWeatherClient.configure do |config|
  config.load_from_rails_credentials
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qurasoft/open_weather_client-caching-redis.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
