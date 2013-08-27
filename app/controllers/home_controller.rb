class HomeController < ApplicationController
  def index
    @recent  = Source.where( :private => false ).page( params[:page] )
    @popular = Source.where( :private => false ).where( 'created_at >= ?', Time.now.to_i - 3600 * 24 * 60 ).popular.page( params[:page] )
    @cloud   = Rails.cache.fetch 'shuffled_cloud_with_70_items', :expires_in => 24.hours do 
      Tag.
        joins(:sources).
        group( 'tags.id' ).
        where( 'sources.language_id NOT IN ( ? )', langs_by_names( :css, :html, :javascript, :actionscript, 'actionscript-3' ).map(&:id) ).
        where( 'LENGTH(tags.value) >= 4' ).
        order( 'sources_count DESC, weight DESC' ).
        limit( 70 ).
        to_a.
        shuffle!
    end
  end
end
