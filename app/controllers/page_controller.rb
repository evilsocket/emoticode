class PageController < ApplicationController
  def show
    @page = Page.find_by_name! params[:name]
  end
end
