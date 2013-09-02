cache "sitemap_languages_#{Source.public.count}" do

  xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
    @languages.each do |language|
      xml.url do
        xml.loc language_archive_url(:name => language.name)
        last_source = language.sources.where(:private => false).order('created_at DESC').limit(1).first
        xml.lastmod Time.at( last_source.created_at ).strftime('%F') unless last_source.nil? 
        xml.changefreq("daily")
        xml.priority(0.8)
      end
    end
  end

end
