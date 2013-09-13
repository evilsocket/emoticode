Raven.configure do |config|
  data = Rails.application.config.secrets['Sentry']

  config.dsn = data['dns']
end
