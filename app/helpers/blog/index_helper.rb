module Blog::IndexHelper
  include SeoHelper

  def page_title
    "Blog | emoticode" rescue super
  end
end

