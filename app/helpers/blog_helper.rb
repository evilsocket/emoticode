module Blog::BlogHelper
  include SeoHelper

  def page_title
    raise "OK"
    "Blog | emoticode" rescue super
  end
end

