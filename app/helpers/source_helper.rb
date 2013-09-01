module SourceHelper
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
    Rails.cache.fetch "highlighted_source_#{source.id}", :expires_in => 7.days do
      code = Albino.colorize source.text, source.language.syntax
      code.empty? ? "<pre>#{h(source.text)}</pre>" : code
    end
  end
end
