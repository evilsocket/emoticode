require 'xmlrpc/client'

namespace :blog do
  desc "Posts random sources on the Wordpress Blog"
  task publish_random: :environment do
    config  = Rails.application.config.secrets['Blog']
    sources = Source.public.order('RAND()').limit(5)
    blog    = XMLRPC::Client.new( config['url'], '/xmlrpc.php' )
    categories = blog.call( 'wp.getCategories', 1, config['username'], config['password'] )

    sources.each do |source|
      puts "Posting #{source.title} ..."

      post_cats  = [ source.language.title, 'Snippets' ]

      post_cats.each do |cat|
        unless categories.map { |c| c['categoryName'] == cat }.include? true
          puts "Creating category #{cat} ..."

          blog.call( 'wp.newTerm', 1, config['username'], config['password'], { 'name' => cat, 'taxonomy' => 'category' } )
        end
      end

      post = {
        'title'       => "#{source.language.title} - #{source.title}",
        'description' => source.description!,
        'mt_keywords' => source.tags.map(&:value),
        'categories'  => post_cats
      }

      blog.call( 'metaWeblog.newPost', 1, config['username'], config['password'], post, true )
    end

  end
end
