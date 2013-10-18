require 'seo_helper'
require 'link_helper'

module ApplicationHelper
  include SeoHelper
  include LinkHelper

  EVENT_ICONS = {
    Event::TYPES[:favorited]        => 'thumbs-up',
    Event::TYPES[:registered]       => 'user',
    Event::TYPES[:sent_nth_content] => 'file-text',
    Event::TYPES[:commented]        => 'comments',
    Event::TYPES[:logged_in]        => 'ok-circle',
    Event::TYPES[:views_reached]    => 'eye-open' 
  }

  def page_title
    paged "emoticode - Snippets and Source Code Search Engine"
  end

  def metas
    make_seo do |seo|
      # default metas ^^
    end
  end

  def cache_if(condition, name = {}, &block)
    if condition
      cache(name, &block)
    else
      yield
    end
  end

  def cache_expire_if(condition, name = {}, expire, &block)
    if condition
      cache( name, :expires_in => expire, &block )
    else
      yield
    end
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

    link_to_language language, attrs
  end

  def tag_with_class_if( tag, clazz, condition, attributes = {}, &block )
    if condition
      attributes['class'] = clazz
    end

    content_tag( tag, attributes, &block )
  end

  def modal_dialog( id, title, attrs = {} )
    attrs = { :class => 'dialog', :id => id }.merge(attrs)
    content_tag :div, attrs do
      content_tag( :div, :class => 'title' ) { title } +
      content_tag( :div, :class => 'content' ) do
        yield
      end
    end
  end

  def event_icon(event)
    "<i class=\"icon-#{EVENT_ICONS[event.eventable_type]}\"></i>".html_safe
  end

  def tag_cloud( tags, min_size = 9, max_size = 20 )
    cloud = {}

    unless tags.empty?
      min, max = tags.map(&:sources_count).minmax
      log_min = Math.log( min )
      log_max = Math.log( max )
      log_delta = log_max - log_min
      size_delta = max_size - min_size

      tags.each do |tag|
        weight = ( Math.log(tag.sources_count) - log_min ) / log_delta
        size = if weight.nan?
                 min_size
               else
                 min_size + ( size_delta * weight ).round
               end

        cloud[tag.value] = [ tag, size, tag.sources_count ]
      end
    end

    cloud
  end

  def adsense( opts = {} )
    opts = { :client => 'ca-pub-5373888916618771' }.merge(opts)
    vars = <<END
google_ad_client = "#{opts[:client]}";
google_ad_slot   = "#{opts[:slot]}";
google_ad_width  = #{opts[:width]};
google_ad_height = #{opts[:height]};
END

    content_tag :div, { :style => "width:#{opts[:width]}px;height:#{opts[:height]}px;" } do
      javascript_tag(vars) +
      javascript_include_tag("//pagead2.googlesyndication.com/pagead/show_ads.js")
    end
  end

  def signed_in?
    !@current_user.nil?
  end

  def avatar_tag(user)
    content_tag :figure, { :class => 'avatar' } do
      image_tag image_url(user.avatar), :height => '50', :width => '50', :alt => "#{user.username} avatar.", :onerror => "this.src='#{image_url("/avatars/default.png")}';"
    end
  end

  def nested_comments(object)
    # select every comment for this object
    comments = object.comments.order('created_at ASC')
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
