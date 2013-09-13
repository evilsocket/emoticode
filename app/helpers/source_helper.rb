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
    if source.description.nil? or source.description.strip.empty?
      '<em>No description :/</em>'.html_safe
    else
      strip_tags( source.description.strip )
      .gsub( /\n/, '<br/>' )
      .gsub( /(https?:\/\/[A-z0-9~@$%&*_\-\.+\/'=#\?]+)/i, '<a href="\1" target="_blank" rel="nofollow">\1</a>' )
    end
  end

  def highlight(source)
    Rails.cache.fetch "#{Digest::MD5.hexdigest( source.text )}_highlighted_source", :expires_in => 7.days do
      if source.language.syntax == 'php'
        if source.text[0].strip != '<'
          source.text = "<?php\n" + source.text
        end
      end
      code = Albino.colorize source.text, source.language.syntax
      code.empty? ? "<pre>#{h(source.text)}</pre>" : code
    end
  end
end
