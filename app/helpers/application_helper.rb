module ApplicationHelper
  # I hate those deprecation warnings -.-
  def link_to_function(name, *args, &block)
    html_options = args.extract_options!.symbolize_keys

    function = block_given? ? update_page(&block) : args[0] || ''
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def link_to( body, url, attrs = {})
    attrs =  { :title => body }.merge(attrs)
    super
  end

  def link_icon_to( body, icon, url, attrs = {} )
    attrs =  { :title => body, :class => 'iconic' }.merge(attrs)    
    link_to "<i class=\"icon-#{icon}\"></i> #{body}".html_safe, url, attrs
  end

  def link_icon_to_function( body, icon, js, attrs = {} )
    attrs = { :class => 'iconic' }.merge(attrs)
    link_to_function "<i class=\"icon-#{icon}\"></i> #{body}".html_safe, js, attrs
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
      description = if !@source.description.nil? && !@source.description.empty?
                      @source.description
                    else
                      title
                    end

    elsif @language
      description = seo['description']['language'] % @language.title, @language.title
      keywords    = seo['keywords']['language'] % @language.title, @language.title, @language.title, @language.title, @language.title

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

  def modal_dialog( id, title )
    content_tag :div, :class => 'dialog', :id => id do
      content_tag( :div, :class => 'title' ) { title } +
      content_tag( :div, :class => 'content' ) do
        yield
      end
    end 
  end

  def tag_cloud( tags, min_size = 9, max_size = 20 )
    min, max = tags.map(&:sources_count).minmax
    log_min = Math.log( min )
    log_max = Math.log( max )
    log_delta = log_max - log_min
    size_delta = max_size - min_size
    cloud = {}

    tags.each do |tag|
      weight = ( Math.log(tag.sources_count) - log_min ) / log_delta
      size = if weight.nan?
               min_size
             else
               min_size + ( size_delta * weight ).round
             end
      
      cloud[tag.value] = [ tag, size, tag.sources_count ]
    end

    cloud
  end

  def signed_in?
    !@current_user.nil?
  end

  def avatar_tag(user)
    image_tag user.avatar, :class => 'avatar', :alt => "#{user.username} avatar."
  end

  def nested_comments(object)
    # select every comment for this object
    comments = object.comments.order('created_at DESC')
    # get root objects ( with no parent )
    threads  = comments.select { |c| c.parent_id.nil? }
    # recurse every thread and group comments by their parents
    nested   = threads.map { |root| group_comments root, comments }
  end

  private 

  def group_comments( parent, comments )
    comments.each do |comment|
      if parent.id == comment.parent_id
        parent.children << group_comments( comment, comments )
      end
    end

    parent
  end
end
