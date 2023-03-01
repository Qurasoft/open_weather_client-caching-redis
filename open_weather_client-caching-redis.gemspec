# frozen_string_literal: true

require_relative 'lib/open_weather_client-caching-redis/caching/redis/version'

Gem::Specification.new do |spec|
  spec.name = 'open_weather_client-caching-redis'
  spec.version = OpenWeatherClient::Caching::Redis::VERSION
  spec.required_ruby_version = '>= 2.6.0'
  spec.authors = ['Lucas Keune']
  spec.email = ['lucas.keune@qurasoft.de']

  spec.summary = 'Redis caching for OpenWeatherClient'
  spec.description = ''
  spec.homepage = 'https://github.com/Qurasoft/open_weather_client-caching-redis'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Qurasoft/open_weather_client-caching-redis'
  spec.metadata['changelog_uri'] = 'https://github.com/Qurasoft/open_weather_client-caching-redis/blob/main/CHANGES.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'open_weather_client', '>= 0.1.5'
  spec.add_dependency 'redis', '>= 4.5.0'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
