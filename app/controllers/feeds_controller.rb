class FeedsController < ApplicationController
  def feed
    @cached  = "main_feed"
    @sources = Source.public.limit(50) 
    render_feed
  end

  def language
    @language = @languages.select { |l| l.name == params[:language] }.first
    if @language 
      @cached  = "language_#{@language.id}_feed"        
      @sources = @language.sources.public.limit(50) 
      render_feed
    else
      render_404
    end
  end

  def user
    @user = User.find_by_username( params[:username] )
    if @user
      @cached  = "user_#{@user.id}_feed"
      @sources = @user.sources.public.order('created_at DESC').limit(50) 
      render_feed
    else
      render_404
    end
  end

  def random
    @sources = Source.where(:private => false).order('RAND()').limit(5)
    @cached  = nil
    render_feed 
  end

  def stream
    @user = User.find_by_username( params[:username] )
    if @user
      @sources = @user.stream(1) 
      render_feed
    else
      render_404
    end
  end

  def blog
    @sources = Post.order('created_at DESC').limit(50) 
    render_feed
  end

  private

  # DRY !
  def render_feed
      render :template => 'feeds/feed.rss.builder', :content_type => 'text/xml'
  end
end
