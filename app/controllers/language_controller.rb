class LanguageController < ApplicationController
  def archive
    @language = Language.find_by_name params[:name]
    if @language
      @sources = @language.sources.public.page( params[:page] )
      @podium  = @language.most_active_users
      @cloud   = Rails.cache.fetch 'cloud_with_70_items_for_' + @language.name, :expires_in => 24.hours do 
        Tag.
          for_language(@language).
          longer.
          popular.
          limit(70).
          to_a.
          shuffle!
      end
    else
      render_404 
    end
  end
end
