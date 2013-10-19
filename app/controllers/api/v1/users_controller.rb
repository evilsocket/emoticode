class Api::V1::UsersController < Api::V1::ApiController
  def index
    @per_page = 15
    @users    = User.confirmed.paginate( :page => params[:page], :per_page => @per_page )
  end

  def show
    @user = User.find_by_username params[:id]
    @per_page = 15
    @sources = @user.sources.public.paginate( :page => params[:page], :per_page => @per_page )
  end
end 
