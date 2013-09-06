module LinkHelper
  def link_to( body, url, attrs = {})
    attrs =  { :title => body }.merge(attrs)
    super
  end

  # I hate those deprecation warnings -.-
  def link_to_function(name, *args, &block)
    html_options = args.extract_options!.symbolize_keys

    function = block_given? ? update_page(&block) : args[0] || ''
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def link_icon_to( body, icon, url, attrs = {} )
    attrs =  { :title => body, :class => 'iconic' }.merge(attrs)    
    link_to "<i class=\"icon-#{icon}\"></i> #{body}".html_safe, url, attrs
  end

  def link_icon_to_function( body, icon, js, attrs = {} )
    attrs = { :class => 'iconic' }.merge(attrs)
    link_to_function "<i class=\"icon-#{icon}\"></i> #{body}".html_safe, js, attrs
  end
end
