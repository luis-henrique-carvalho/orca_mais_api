Rails.application.config.to_prepare do
  ActiveStorage::Current.url_options = {
    host: ENV.fetch('HOST', 'http://localhost:3000'),
    protocol: 'http'
  }
end
