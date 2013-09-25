class LanguageController < ApplicationController
  def archive
    @language = Language.find_by_name params[:name]
    if @language
      @sources = @language.sources.public.page( params[:page] )
      @podium  = @language.most_active_users
      @cloud   = Tag.cloud(@language).to_a.shuffle!
    else
      render_404 
    end
  end
end
