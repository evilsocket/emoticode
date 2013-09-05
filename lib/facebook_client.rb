class FacebookClient
  def initialize
    @config = Rails.application.config.secrets['Facebook']
    @graph = Koala::Facebook::API.new @config['token']
  end   

  def post( title, url, image )
    @graph.put_connections @config['page_id'], 'feed', :message => title, :picture => image, :link => url
  end
end
