class LanguageController < ApplicationController
  def archive
    @language = @languages.select { |l| l.name == params[:name] }.first
    if @language
      @sources = @language.sources.joins(:user => :profile).where( :private => false ).page( params[:page] )
      @podium  = @language.most_active_users
      @cloud   = Rails.cache.fetch 'shuffled_cloud_with_70_items_for_' + @language.name, :expires_in => 24.hours do 
        Tag.
          joins(:sources).
          group( 'tags.id' ).
          where( 'sources.language_id = ?', @language.id ).
          where( 'LENGTH(tags.value) >= 4' ).
          order( 'sources_count DESC, weight DESC' ).
          limit( 70 ).
          to_a.
          shuffle!
      end
    else
      render_404 
    end
  end
end
