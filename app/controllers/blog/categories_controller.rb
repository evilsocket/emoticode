class Blog::CategoriesController < ApplicationController
  def archive
    @category = Category.find_by_name! params[:category] 
    @posts    = @category.posts.order('created_at DESC').all
  end
end

