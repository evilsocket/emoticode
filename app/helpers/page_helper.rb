module PageHelper
  include SeoHelper

  def page_title
    "#{params[:action].capitalize} | emoticode"
  end

  def metas
    make_seo do |seo|
      seo.description = params[:action].capitalize 
    end
  end
end
