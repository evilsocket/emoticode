cache "sitemap_posts_#{Post.count}" do

  xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
    @posts.each do |post|
      xml.url do
        xml.loc post.url
        xml.lastmod post.created_at.strftime('%F') 
        xml.changefreq("weekly")
        xml.priority(0.8)
      end
    end
  end

end

