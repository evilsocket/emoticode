class Blog::IndexController < ApplicationController
  def show
    @posts = Post.order('created_at DESC').all 
  end
end
