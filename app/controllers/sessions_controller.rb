class SessionsController < ApplicationController
  def facebook_connect
    auth_hash = request.env['omniauth.auth']

    render :text => auth_hash.inspect
  end

  def create
    @user = User.authenticate( params[:session][:who], params[:session][:password] )

    if @user.nil?
      flash[:warning] = 'Invalid username/password'
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      redirect_to root_url
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end 
end

