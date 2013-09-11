class UserController < ApplicationController
  before_filter :not_authenticated!

  def new
    @user = User.new
  end

  def create
    params[:user] = params[:user].merge :status => User::STATUSES[:unconfirmed], :level => User::LEVELS[:subscriber]
    params[:user][:username] = params[:user][:username].parameterize

    @user = User.new( user_params )

    if verify_recaptcha( :model => @user, :message => 'Invalid captcha.' ) and @user.save
      Profile.create({ user: @user })

      UserMailer.confirmation_email(@user, params[:user][:password] ).deliver

      flash[:alert] = 'A confirmation email has been sent to your email address.'
      redirect_to root_url
    else
      render :new
    end
  end

  def confirm
    token = params[:token]

    @user = User.activate( params[:token] )
    if @user.nil?
      flash[:alert] = 'Invalid confirmation token.'
      redirect_to root_url
    else
      sign_in(@user)
      redirect_to user_settings_url
    end
  end

  private

  def user_params
    params.require(:user).permit( :username, :email, :password, :password_confirmation, :status, :level )
  end
end
