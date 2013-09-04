Recaptcha.configure do |config|
  data = Rails.application.config.secrets['Recaptcha']
  
  config.public_key  = data['public_key']
  config.private_key = data['private_key']
end
