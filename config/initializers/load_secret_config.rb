Rails.application.config.secrets = YAML.load_file("#{Rails.root.to_s}/config/secrets.yml")
