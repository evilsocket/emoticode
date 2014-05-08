module SourceHelper
  include SeoHelper

  def page_title
    "#{@source.language.title} - #{@source.title} | emoticode" rescue super
  end

  def metas
    make_seo do |seo|
      seo.description = @source.description! page_title
      seo.keywords    = @source.tags.map(&:value).join ', '
    end
  end

  def description(source)
    source.description! '*No description :/*', true
  end
end
