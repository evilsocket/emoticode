class Blog::PostsController < ApplicationController
  before_filter :authenticate!,  only: [ :new, :create, :edit, :update, :destroy ]  
  before_filter :admin!, only: [ :new, :create, :edit, :update, :destroy ]

  def show
    @post = Post.find_by_name_and_category_name! params[:name], params[:category] 
    @comment = Comment.new
  end

  def new
    @post = Post.new 
    @category = Category.find_by_name! params[:category]    
  end

  def create
    @category = Category.find_by_name! params[:category]
    
    params[:post] = params[:post].merge(:user_id => @current_user.id, :category_id => @category.id )

    @post = Post.create post_params
    if @post.valid?
      redirect_to blog_show_post_path( :category => @category.name, :name => @post.name )
    else
      flash[:error] = @post.errors.full_messages
      redirect_to blog_new_post_path( :category => @category.name )
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    @post = Post.find params[:id]
    if @post.update_attributes( post_params )
      redirect_to blog_show_post_path( :category => @post.category.name, :name => @post.name )
    else
      flash[:error] = @post.errors.full_messages
      redirect_to blog_post_edit_path(:id => @post.id)
    end 
  end

  def destroy
    @post = Post.find params[:id] 
    @post.destroy
    redirect_to '/blog/'
  end

  private

  def admin!
    if @current_user.is_admin? == false
      redirect_to root_url
    end
  end

  def post_params
    params.require(:post).permit( :user_id, :category_id, :title, :body ) 
  end 
end

