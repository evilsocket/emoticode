class Api::V1::LanguagesController < Api::V1::ApiController
  def index
    @languages = Language.all 
  end

  def show
    @language = Language.find_by_name params[:id]
    @per_page = 15
    @sources  = @language.sources.public.paginate( :page => params[:page], :per_page => @per_page )
  end
end
