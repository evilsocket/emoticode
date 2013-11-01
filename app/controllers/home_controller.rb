class HomeController < ApplicationController
  def index
    if !@current_user.nil?
      pager_params = { :page => params[:page], :per_page => 16 }

      @sources = @current_user.stream.paginate pager_params
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
