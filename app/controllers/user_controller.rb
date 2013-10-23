class UserController < ApplicationController
  before_filter :not_authenticated!

  def new
    @user = User.new
  end

  def create
    params[:user] = params[:user].merge :status => User::STATUSES[:unconfirmed], :level => User::LEVELS[:subscriber]
    params[:user][:username] = params[:user][:username].parameterize

    @user = User.new( user_params )

    valid_captcha = verify_recaptcha( :model => @user, :message => 'Invalid captcha.' )

    # valid catpcha but bot detected
    if valid_captcha and ( params[:antibot].nil? or params[:antibot].empty? == false )
      AlertMailer.spammer_alert_email( params, request ).deliver
      redirect_to root_url
    # valid captcha and valid user -> register
    elsif valid_captcha and @user.save
      Profile.create({ user: @user })
     
      UserMailer.confirmation_email(@user, params[:user][:password] ).deliver

      flash[:alert] = 'A confirmation email has been sent to your email address.'
      redirect_to root_url
      # something's not valid
    else
      render :new
    end
  end

  def confirm
    token = params[:token]
    @user = User.activate( params[:token] )
    if @user.nil?
      flash[:alert] = 'Invalid confirmation token.'
    else
      sign_in(@user)
    end

    # TODO: Set show_intro cookie
    redirect_to root_url    
  end

  private

  def user_params
    params.require(:user).permit( :username, :email, :password, :password_confirmation, :status, :level )
  end
end
