module SourceHelper
  def description(source)
    if source.description.nil?
      '<em>No description :/</em>'.html_safe
    else
    strip_tags( source.description.strip )
    .gsub( /\n/, '<br/>' )
    .gsub( /(https?:\/\/[A-z0-9~@$%&*_\-\.+\/'=#\?]+)/i, '<a href="\1" target="_blank" rel="nofollow">\1</a>' )
    end
  end

  def highlight(source)
    code = Albino.colorize source.text, source.language.syntax
    code.empty? ? "<pre>#{h(source.text)}</pre>" : code
  end
end
