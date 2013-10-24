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
      require 'redcarpet'

      renderer   = Redcarpet::Render::HTML.new
      extensions = {fenced_code_blocks: true}
      redcarpet  = Redcarpet::Markdown.new(renderer, extensions)

      redcarpet.render encoder.encode( source.description )
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

  private

  def encoder
    @encoder ||= HTMLEntities.new
  end
end
