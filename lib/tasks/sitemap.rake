namespace :sitemap do
  desc "Ping Google and Bing for sitemap submission."
  task submit: :environment do
    Sitemaps = [ 'http://www.emoticode.net/sitemap_index.xml' ]
    Services = [ 'http://www.google.com/webmasters/sitemaps/ping?sitemap=', 'http://www.bing.com/webmaster/ping.aspx?siteMap=' ]

    Sitemaps.each do |sitemap|
      Services.each do |service|
        open( "#{service}#{sitemap}" ).read
      end
    end

  end
end