class SessionsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    if omniauth
      @user = User.omniauth(omniauth)
      # TODO: Check if it's a new user and send temporary password
    else
      @user = User.authenticate( params[:session][:who], params[:session][:password] )
    end

    process_user
  end

  def destroy
    sign_out
    redirect_to root_url
  end 

  private

  def process_user
    if @user.nil? or !@user.valid?
      flash[:error] = 'Invalid username/password'
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      redirect_to root_url
    end
  end
end

