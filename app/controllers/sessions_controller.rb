class SessionsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    if omniauth
      @user, temporary_password = User.omniauth(omniauth)
      # this is a first time user, send him its temporary password
      unless @user.nil? or !@user.valid? or temporary_password.nil?
        UserMailer.omniauth_confirmation_email( @user, omniauth['provider'], temporary_password ).deliver
        flash[:alert] = 'A temporary password has been sent to your email address.'
      end
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

