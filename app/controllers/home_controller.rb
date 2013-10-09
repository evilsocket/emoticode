class HomeController < ApplicationController
  def index
    pager_params = { :page => params[:page], :per_page => 16 }

    @popular = Source.public.by_trend.newer_than( 2.months.ago.to_i ).paginate pager_params
    @cloud   = Tag.cloud.to_a.shuffle!
  end

  def recent
    pager_params = { :page => params[:page], :per_page => 16 }
    
    @recent  = Source.public.paginate pager_params
    @cloud   = Tag.cloud.to_a.shuffle!    
  end
end
