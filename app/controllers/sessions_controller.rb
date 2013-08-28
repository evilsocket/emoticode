class SessionsController < ApplicationController

  def facebook_connect
    omniauth = request.env['omniauth.auth']
    @user = User.omniauth(omniauth)
    # TODO: Check if it's a new user and send temporary password
    process_user
  end

  def create
    @user = User.authenticate( params[:session][:who], params[:session][:password] )
    process_user
  end

  def destroy
    sign_out
    redirect_to root_url
  end 

  private

  def process_user
    if @user.nil? or !@user.valid?
      flash[:warning] = 'Invalid username/password'
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      redirect_to root_url
    end
  end
end

