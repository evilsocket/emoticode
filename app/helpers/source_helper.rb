module SourceHelper
  def description(source)
    simple_format( strip_tags( source.description ) ).gsub( /(https?:\/\/[A-z0-9~@$%&*_\-\.+\/'=#\?]+)/i, '<a href="\1" target="_blank" rel="nofollow">\1</a>' )
  end

  def highlight(source)
    code = Albino.colorize source.text, source.language.syntax
    code.empty? ? "<pre>#{h(source.text)}</pre>" : code
  end
end
