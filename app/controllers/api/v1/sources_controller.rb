class Api::V1::SourcesController < Api::V1::ApiController
  def index
    @per_page = 15
    @sources = Source.public.paginate( :page => params[:page], :per_page => @per_page )
  end

  def show
    @source = Source.find params[:id]
  end
end 
