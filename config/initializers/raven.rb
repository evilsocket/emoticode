Raven.configure do |config|
  data = Rails.application.config.secrets['Sentry']

  config.dns = data['dns']
end
