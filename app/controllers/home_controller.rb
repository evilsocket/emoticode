class HomeController < ApplicationController
  def index
    if !@current_user.nil?
      pager_params = { :page => params[:page], :per_page => 16 }

      follows      = @current_user.follows.by_type
      language_ids = []
      user_ids     = []
      
      follows.each do |follow|
        if follow.follow_type.to_i == Follow::TYPES[:user]
          user_ids << follow.user.id
        elsif follow.follow_type.to_i == Follow::TYPES[:language]
          language_ids << follow.language.id
        end
      end

      @sources = Source.public.where(['user_id IN ( ? ) OR language_id IN ( ? )', user_ids, language_ids]).paginate pager_params
      @cloud   = Tag.cloud.shuffle!
    else
      pager_params = { :page => params[:page], :per_page => 16 }

      @sources = Source.public.by_trend.newer_than( 2.months.ago.to_i ).paginate pager_params
      @cloud   = Tag.cloud.shuffle!
    end
  end

  def trending
    pager_params = { :page => params[:page], :per_page => 16 }

    @sources = Source.public.by_trend.newer_than( 2.months.ago.to_i ).paginate pager_params
    @cloud   = Tag.cloud.shuffle!
  end

  def recent
    pager_params = { :page => params[:page], :per_page => 16 }
    
    @recent  = Source.public.paginate pager_params
    @cloud   = Tag.cloud.shuffle!    
  end
end
