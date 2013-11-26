class Api::V1::SourcesController < Api::V1::ApiController
=begin
  def index
    @per_page = 15
    @sources = Source.public.paginate( :page => params[:page], :per_page => @per_page )
  end

  def show
    @source = Source.find params[:id]
  end
=end

  respond_to :json

  def create
    resp = { :errors => nil, :data => nil }

    @language = Language.find_by_name! params[:source][:language]

    params[:source] = params[:source].merge(:user_id => @current_user.id, :language_id => @language.id )

    @source = Source.create source_params
    
    if @source.valid?
      user_sources = @current_user.sources.count

      if user_sources == 1 or user_sources % Event::CONTENT_STEP == 0
        Event.new_nth_content( @current_user, @source, user_sources )
      end

      resp[:data] = @source.url 
    else
      resp[:errors] = @source.errors.full_messages
      begin
        @source.destroy
      rescue
      end
    end

    render :json => resp
  end

  private

  def source_params
    params.require(:source).permit( :language_id, :user_id, :title, :private, :description, :text ) 
  end 

end 
