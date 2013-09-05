class TwitterClient
  def initialize
    @config = Rails.application.config.secrets['Twitter']
    @client = Twitter::Client.new(
      :consumer_key => @config['consumer_key'],
      :consumer_secret => @config['consumer_secret'],
      :oauth_token => @config['oauth_token'],
      :oauth_token_secret => @config['oauth_secret']
    )
  end

  def post( title, link, hashes = [] )
    message = "#{title} #{link}"
    hashes = hashes.map { |h| "##{h}" }.join ' '

    if message.length + hashes.length < 140
      message << " #{hashes}"
    end

    @client.update message
  end
end
