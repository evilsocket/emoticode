module ApplicationHelper
  def link_to( body, url, attrs = {})
    attrs =  { :title => body }.merge(attrs)
    super
  end

  def navbar_language_link( language )
    # if we are not under a specific language archive, obtain current 
    # language from the current shown source if any
    @language ||= if @source then @source.language else nil end
    attrs = if @language && @language == language
              { :class => 'current' }
            else
              {}
            end

    link_to language.title, language_archive_path(language.name), attrs
  end

  def tag_with_class_if( tag, clazz, condition, attributes = {}, &block )
    if condition
      attributes['class'] = clazz
    end

    content_tag( tag, attributes, &block )
  end

  def page_title
    base_title = 'emoticode'
    subtitle   = 'Snippets and Source Code Search Engine'

    page_title = if @source
                   "#{@source.language.title} - #{@source.title} | #{base_title}"

                 elsif @language
                   "#{@language.title} Snippets | #{base_title}"

                 elsif @user
                   "#{@user.username} | #{base_title}"

                 else
                   "#{base_title} - #{subtitle}"
                 end

    if params[:page].to_i > 1 
      page_title << " ( Page #{params[:page]} )"
    end

    page_title
  end

  def metas
    title       = page_title
    description = "EmotiCODE is a code snippet search engine but mostly a place where developers can find help for what they need and contribute with their own contents."
    keywords    = "emoticode, snippets, code snippets, source, source code, programming, programmer, #{@languages.map(&:title).join(', ')}"

    if @source
      keywords    = @source.tags.map(&:value).join(', ')
      description = if !@source.description.nil? && !@source.description.empty?
                      @source.description
                    else
                      title
                    end

    elsif @language
      description = "#{@language.title} Snippets from EmotiCODE, a #{@language.title} code snippet search engine but mostly a place where developers can find help for what they need and contribute with their own contents."
      keywords    = "#{@language.title} snippets, #{@language.title} code, #{@language.title} codes, #{@language.title} code snippets, #{@language.title} snippet archive" 

    elsif @user
      description = "#{@user.username} EmotiCODE Profile"

    end

    if params[:page].to_i > 1 
      description << " ( Page #{params[:page]} )"
    end

    [
      { charset: 'utf-8' },
      { property: 'og:locale', content: 'en_US' },
      { property: 'og:site_name', content: 'emoticode' },
      { property: 'og:image', content:'http://www.emoticode.net/assets/style/logo-200.png?v=2.1' },
      { property: 'og:description', content: description },
      { property: 'fb_app_id', content: '541383999216397' },
      { property: 'fb:app_id', content: '541383999216397' },
      { property: 'og:url', content: 'http://www.emoticode.net/' },
      { name: 'language', content: 'en' },
      { name: 'title', content: title },
      { name: 'description', content: description },
      { name: 'keywords', content: keywords },
      { name: 'robots', content: 'noodp,noydr' },
      { name: 'alexaVerifyID', content: 'esKfarSO5NWalbJaefzTwaUzso' },
      { name: 'msvalidate.01', content: '9C2A48C8F5733D97CD13C5EB3699308D' },
      { name: 'google-site-verification', content: 'Uy9LP869XtH59q7mfCgyOd4CS5XifoRgROn0wJ8d8MU' }
    ]
  end 

  def signed_in?
    !@current_user.nil?
  end
end
