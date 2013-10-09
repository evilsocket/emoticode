module HomeHelper
  def page_title
    "#{super} | #{controller.action_name.capitalize}"
  end
end
