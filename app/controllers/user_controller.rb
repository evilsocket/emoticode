class UserController < ApplicationController
  before_filter :not_authenticated!

  def new
    @user = User.new
  end

  def create
    @user = User.create({ 
      username: params[:user][:username], 
      email: params[:user][:email], 
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      status: User::STATUSES[:unconfirmed], 
      level: User::LEVELS[:subscriber]
    })

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
end
