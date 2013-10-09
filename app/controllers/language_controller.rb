class LanguageController < ApplicationController
  def archive
    @language = Language.find_by_name params[:name]
    if @language
      @sources = @language.sources.public.paginate( :page => params[:page], :per_page => 16 )
      @podium  = @language.most_active_users
      @cloud   = Tag.cloud(@language).to_a.shuffle!
    else
      render_404 
    end
  end
end
