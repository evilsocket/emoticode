xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "EmotiCODE - Snippets and Source Code Search Engine"
    xml.description "EmotiCODE is a code snippet search engine but mostly a place where developers can find help for what they need and contribute with their own contents."
    xml.link "http://www.emoticode.net/"

    @sources.each do |source|
      xml.item do
        xml.title source.title
        xml.description source.description! 
        xml.pubDate Time.at( source.created_at ).to_s(:rfc822)
        xml.link source.url
        xml.guid source.url
      end
    end
  end
end

