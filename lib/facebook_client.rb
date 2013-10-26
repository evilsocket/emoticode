require 'open-uri'
require 'json'

class FacebookClient
  def initialize
    @config = Rails.application.config.secrets['Facebook']
    @graph = Koala::Facebook::API.new @config['token']
  end   

  def post( title, url, image = 'http://www.emoticode.net/logo_2.0_200.png' )
    @graph.put_connections @config['page_id'], 'feed', :message => title, :picture => image, :link => url
  end

  def followers
    Rails.cache.fetch "FacebookClient#followers", :expire => 60.minutes do
      data = open("http://api.facebook.com/method/fql.query?format=json&query=select+fan_count+from+page+where+page_id%3D#{@config['page_id']}").read    
      obj = JSON.parse(data)[0]
      obj["fan_count"].to_i
    end
  end
end
