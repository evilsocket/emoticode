class FeedsController < ApplicationController
  def feed
    @cached  = "feed_#{Source.public.count}"
    @sources = Source.public.limit(50) 
    render_feed
  end

  def language
    @language = @languages.select { |l| l.name == params[:language] }.first
    if @language 
      @cached  = "language_feed_#{@language.sources.public.count}"        
      @sources = @language.sources.public.limit(50) 
      render_feed
    else
      render_404
    end
  end

  def user
    @user = User.find_by_username( params[:username] )
    if @user
      @cached  = "user_feed_#{@user.sources.public.count}"
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
      @sources = @user.stream.order('created_at DESC').limit(50) 
      render_feed
    else
      render_404
    end
  end

  private

  # DRY !
  def render_feed
      render :template => 'feeds/feed.rss.builder', :content_type => 'text/xml'
  end
end
