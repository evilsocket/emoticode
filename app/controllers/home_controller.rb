class HomeController < ApplicationController
  def index
    @recent  = Source.public.page( params[:page] )
    @popular = Source.public.by_trend.newer_than( 2.months.ago.to_i ).page( params[:page] )
    @cloud   = Tag.cloud.to_a.shuffle!
  end
end
