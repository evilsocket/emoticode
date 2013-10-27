require 'open-uri'
require 'json'

class GooglePlusClient
  def initialize
    @config = Rails.application.config.secrets['Google']
  end   

  def followers
    Rails.cache.fetch "GooglePlusClient#followers", :expire => 60.minutes do
      data = open("https://www.googleapis.com/plus/v1/people/105672627985088123672?key=#{@config['api_key']}").read    
      obj = JSON.parse(data)
      obj['plusOneCount'].to_i
    end
  end
end

