class LanguageController < ApplicationController
  def archive
    @language = @languages.select { |l| l.name == params[:name] }.first
    if @language
      @sources = @language.sources.with_user_profile.public.page( params[:page] )
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
