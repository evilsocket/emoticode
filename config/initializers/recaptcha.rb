Recaptcha.configure do |config|
  data = Rails.application.config.secrets['Recaptcha']
  
  ENV['RECAPTCHA_PUBLIC_KEY']  = config.public_key  = data['public_key']
  ENV['RECAPTCHA_PRIVATE_KEY'] = config.private_key = data['private_key']
end
