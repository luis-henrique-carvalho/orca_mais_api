source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "dotenv-rails", groups: [ :development, :test ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "rack-cors"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.12.1"
gem "pagy", "~> 9.3"
gem "blueprinter"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "annotaterb"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.5"
end

group :test do
  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov_json_formatter", "~> 0.1.4", require: false
  gem "shoulda-matchers", "~> 6.4"
  gem "database_cleaner-active_record", "~> 2.2"
end
