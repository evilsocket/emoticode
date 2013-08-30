class FeedsController < ApplicationController
  def feed
    @sources = Source.where(:private => false).order('created_at DESC').limit(50) 
    render_feed
  end

  def language
    @language = @languages.select { |l| l.name == params[:language] }.first
    if @language 
      @sources = Source.where(:private => false).where(:language => @language).order('created_at DESC').limit(50) 
      render_feed
    else
      render_404
    end
  end

  def user
    @user = User.find_by_username( params[:username] )
    if @user
      @sources = Source.where(:private => false).where(:user_id => @user.id).order('created_at DESC').limit(50) 
      render_feed
    else
      render_404
    end
  end

  def random
    @sources = Source.where(:private => false).order('RAND()').limit(5) 
    render_feed 
  end

  private

  # DRY !
  def render_feed
      render :template => 'feeds/feed.rss.builder', :content_type => 'text/xml'
  end
end
