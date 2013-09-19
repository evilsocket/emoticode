class HomeController < ApplicationController
  def index
    @recent  = Source.where( :private => false ).joins(:language,:user => :profile).page( params[:page] )
    @popular = Source.where( :private => false ).
      select('sources.*, ( sources.views / ( ( UNIX_TIMESTAMP() - sources.created_at ) / ( 3600 *24 ) ) ) AS trend').
      joins(:language,:user => :profile).
      order('trend desc').
      where( 'sources.created_at >= ?', 2.months.ago.to_i ).
      page( params[:page] )
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
