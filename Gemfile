# frozen_string_literal: true

source 'https://rubygems.org'

gem 'blueprinter'
gem 'bootsnap', require: false
gem 'devise', '~> 4.9'
gem 'devise-jwt', '~> 0.12.1'
gem 'dotenv-rails', groups: %i[development test]
gem 'kamal', require: false
gem 'pagy', '~> 9.3'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rack-cors'
gem 'rails', '~> 8.0.1'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'annotaterb'
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.5'
  gem 'rspec-rails', '~> 7.1'

  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov_json_formatter', '~> 0.1.4', require: false
end
