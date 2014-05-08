class SessionsController < ApplicationController
  before_filter :not_authenticated!, :except => [:destroy]

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

    # TODO: if first login, set show_intro cookie

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
      Event.new_login(@user)
      sign_in(@user)

      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

      redirect_to request.referer || root_url
    end
  end
end

