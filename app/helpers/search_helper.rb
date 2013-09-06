module SearchHelper
  include SeoHelper
  
  def page_title
    paged "Search '#{@phrase}' | emoticode" 
  end

  def metas
    make_seo do |seo|
      seo.description = paged seo.search.description % @phrase 
    end
  end
end
