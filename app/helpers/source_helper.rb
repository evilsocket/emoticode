module SourceHelper
  include SeoHelper

  def page_title
    "#{@source.seo_title} | emoticode" rescue super
  end

  def metas
    make_seo do |seo|
      seo.description = @source.seo_description page_title
      seo.keywords    = @source.seo_keywords
    end
  end

  def description(source)
    source.description! '*No description :/*', true
  end
end
