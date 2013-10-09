module HomeHelper
  def page_title
    paged "#{super} | #{controller.action_name.capitalize}"
  end
end
