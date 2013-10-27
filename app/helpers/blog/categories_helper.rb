module Blog::CategoriesHelper
  include SeoHelper

  def page_title
    "Blog - #{@category.title} | emoticode" rescue super
  end

  def metas
    make_seo do |seo|
      seo.description = paged "#{@category.title} blog archive."
    end
  end
end


