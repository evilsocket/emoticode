module LanguageHelper
  include SeoHelper

  def page_title
    paged "#{@language.title} Snippets | emoticode"
  end

  def metas
    make_seo do |seo|
      seo.description = paged seo.language.description % Array.new( 2, @language.title ) 
      seo.keywords    = seo.language.keywords % Array.new( 5, @language.title )
    end
  end
end
