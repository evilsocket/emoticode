require 'twitter_client'
require 'facebook_client'

namespace :social do
  desc "Posts 2 random sources on Twitter and Facebook"
  task publish_random: :environment do
    twitter  = TwitterClient.new
    facebook = FacebookClient.new

    Source.public.order('RANDOM()').limit(2).each do |source|
      begin
        puts "Posting #{source.title} ..."

        facebook.post source.title, source.url
        twitter.post source.title, source.short_url, [ source.language.name.replace('-',''), 'snippet' ] 
        
      rescue Exception => e
        puts "ERROR: #{e.message}"
      end
    end 
  end

end
