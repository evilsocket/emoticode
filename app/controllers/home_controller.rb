class HomeController < ApplicationController
  def index
    base  = Source.where( :private => false ).joins(:language,:user => :profile)

    @recent  = base.page( params[:page] )
    @popular = base.where( 'sources.created_at >= ?', 2.months.ago.to_i ).popular.page( params[:page] )
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
