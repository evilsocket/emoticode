require 'open-uri'
require 'json'

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

  def followers
    Rails.cache.fetch "TwitterClient#followers", :expire => 60.minutes do
      data = open("http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20from%20html%20where%20url=%22http://twitter.com/EmotiCodeDotNet%22%20AND%20xpath=%22(//a[@class=\'js-nav\']/strong)[3]%22&format=json").read    
      obj = JSON.parse(data)
      obj['query']['results']['strong'].to_i
    end
  end
end
