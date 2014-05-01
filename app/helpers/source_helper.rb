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

  def highlight(source)
    #Rails.cache.fetch "#{Digest::MD5.hexdigest( source.text )}_highlighted_source", :expires_in => 7.days do
      if source.language.syntax == 'php'
        if source.text[0].strip != '<'
          source.text = "<?php\n" + source.text
        end
      end
      code = Albino.new( source.text, source.language.syntax).to_s('O' => 'linenos=inline')
      code.empty? ? "<pre>#{h(source.text)}</pre>" : code
    #end
  end
end
