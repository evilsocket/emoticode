class SourceController < ApplicationController
  before_filter :authenticate!,  only: [ :new, :raw, :create, :edit, :update, :destroy ]
  before_filter :owner_or_admin!, only: [ :edit, :update, :destroy ]

  def show
    @source = source_by_params
    if params[:id]
      redirect_to source_with_language_url( :language_name => @source.language.name, :source_name => @source.name )
    else      
      impressionist(@source)

      @cloud = @source.tags.to_a.shuffle
      @comment = Comment.new
    end
  end

  def raw
    show
    render :text => @source.text, :content_type => 'text/plain'
  end

  def embed
    @source = source_by_params
    
    impressionist(@source)
    
    @hash   = Digest::MD5.hexdigest( @source.name )
    render :partial => 'source/embed.js'
  end

  def new
    @source = Source.new
  end

  def create
    params[:source] = params[:source].merge(:user_id => @current_user.id)

    @source = Source.create source_params
    if @source.valid?
      user_sources = @current_user.sources.count

      if user_sources == 1 or user_sources % Event::CONTENT_STEP == 0
        Event.new_nth_content( @current_user, @source, user_sources )
      end

      redirect_to source_with_language_path(language_name: @source.language.name, source_name: @source.name )
    else
      flash[:error] = @source.errors.full_messages
      redirect_to source_new_path(@source)
    end
  end

  def edit
  end

  def update
    if @source.update_attributes( source_params )
      redirect_to source_with_language_path(language_name: @source.language.name, source_name: @source.name )
    else
      flash[:error] = @source.errors.full_messages
      redirect_to source_edit_path(@source)
    end
  end

  def destroy
    @source.destroy
    redirect_to root_url
  end

  private

  def owner_or_admin!
    @source = Source.find( params[:id] )
    if @source.nil?
      render_404
    elsif @current_user != @source.user && @current_user.is_admin? == false
      redirect_to @source.url
    end
  end

  def source_by_params
    if params[:id]
      Source.find params[:id]
    else
      Source.find_by_name_and_language_name!( params[:source_name], params[:language_name] )
    end
  end

  def source_params
    params.require(:source).permit( :language_id, :user_id, :title, :private, :description, :text ) 
  end 
end
