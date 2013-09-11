require 'twitter_client'
require 'facebook_client'

namespace :social do
  desc "Posts 2 random sources on Twitter and Facebook"
  task publish_random: :environment do
    post Source.public.order('RAND()').limit(2)
  end

  desc "Publish new contents on Twitter and Facebook"
  task publish_new: :environment do
    post Source.where(:socialized => false).limit(20)
  end

  def post(sources)
    twitter  = TwitterClient.new
    facebook = FacebookClient.new

    sources.each do |source|
      begin
        puts "Posting #{source.title} ..."

        facebook.post source.title, source.url
        twitter.post "#{source.language.title} - #{source.title}", source.short_url, [ source.language.name.gsub(/\-/,''), 'snippet' ]

        source.socialized = true
        source.save!
      rescue Exception => e
        puts "ERROR: #{e.message}"
      end
    end
  end
end
