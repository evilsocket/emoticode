class HomeController < ApplicationController
  def index
    @recent  = Source.public.page( params[:page] )
    @popular = Source.public.by_trend.newer_than( 2.months.ago.to_i ).page( params[:page] )
    @cloud   = Rails.cache.fetch '70_shuffled_tags_by_sources_count_and_weight', :expires_in => 1.week do 
      Tag.
        with_sources.
        popular.
        limit( 70 ).
        to_a.
        shuffle!
    end
  end
end
