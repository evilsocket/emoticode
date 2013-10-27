cache "sitemap_index_#{@pages}_#{Source.public.count}" do
  xml.sitemapindex(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
    (1..@pages).each do |page|
      xml.sitemap do
        xml.loc sitemap_snippets_url(:page => page, :format => 'xml')
        xml.lastmod Time.at(@last_snippet.created_at).strftime("%F")
      end
    end

    xml.sitemap do
      xml.loc sitemap_posts_url(:format => 'xml')
      xml.lastmod Time.at(@last_post.created_at).strftime("%F")
    end

    xml.sitemap do
      xml.loc sitemap_languages_url(:format => 'xml')
      xml.lastmod Time.at(@last_snippet.created_at).strftime("%F")
    end
  end
end
