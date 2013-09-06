module SeoHelper
  def page_title
    base_title = 'emoticode'

    page_title = if @source and !@source.new_record?
                   "#{@source.language.title} - #{@source.title} | #{base_title}"

                 elsif @language
                   "#{@language.title} Snippets | #{base_title}"

                 elsif @user and !@user.new_record?
                   "#{@user.username} | #{base_title}"

                 elsif @phrase
                   "Search '#{@phrase}' | #{base_title}"

                 else
                   Rails.application.config.seo['title']['default'] 
                 end

    if params[:page].to_i > 1 
      page_title << " ( Page #{params[:page]} )"
    end

    page_title
  end

  def metas
    seo = Rails.application.config.seo

    title       = page_title
    description = seo['description']['default']
    keywords    = seo['keywords']['default'] % @languages.map(&:title).join(', ')

    if @source and !@source.new_record?
      keywords    = @source.tags.map(&:value).join(', ')
      description = @source.description! title
    elsif @language
      description = seo['description']['language'] % Array.new( 2, @language.title )
      keywords    = seo['keywords']['language'] % Array.new( 5, @language.title )
    elsif @user and !@user.new_record?
      description = seo['description']['user'] % @user.username
    elsif @phrase
      description = seo['description']['search'] % @phrase
    end

    if params[:page].to_i > 1 
      description << " ( Page #{params[:page]} )"
    end

    seo['default'] + [
      { property: 'og:description', content: description },
      { name: 'title', content: title },
      { name: 'description', content: description },
      { name: 'keywords', content: keywords },
    ]
  end 

  def link_to_source(source, attrs = {})
    attrs =  { 
      :title => "#{source.language.title} - #{source.title}" 
    }
    .merge(attrs) 

    link_to source.title, source_with_language_url(language_name: source.language.name, source_name: source.name), attrs
  end

  def link_to_language(language, attrs = {})
    attrs =  { 
      :title => "#{language.title} code snippets." 
    }
    .merge(attrs) 

    link_to language.title, language_archive_url(language.name), attrs
  end
end
