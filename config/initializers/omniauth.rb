Rails.application.config.middleware.use OmniAuth::Builder do
  facebook = Rails.application.config.secrets['Facebook']
  github = Rails.application.config.secrets['Github']

  provider :facebook, facebook['api_key'], facebook['api_secret']
  provider :github,   github['api_key'],   github['api_secret'], :scope => 'user:email'
end
