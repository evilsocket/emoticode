module Blog::PostsHelper
  include SeoHelper

  def page_title
    "#{@post.title} | emoticode" rescue super
  end

  def metas
    make_seo do |seo|
      unless @post.id.nil?
        seo.title       = paged @post.title
        seo.description = paged truncate( @post.description!, :length => 250 )
      end
    end
  end
end
