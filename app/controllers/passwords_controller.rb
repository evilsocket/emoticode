class PasswordsController < ApplicationController
  before_filter :not_authenticated!

  def new
  end

  def create
    begin
      @user = User.find_by_email!( params[:password][:email] )

      raise RuntimeException unless valid_captcha = verify_recaptcha( :model => @user, :timeout => 15 )

      UserMailer.password_reset_email( @user ).deliver
    rescue
      flash[:error] = 'Invalid email address or captcha.'
      redirect_to new_passwords_url
    end
  end

  def edit
    @user = User.find_by_confirmation_token( params[:token] )
    render_404 unless @user
  end

  def update
    @user = User.find_by_confirmation_token( params[:token] )
    render_404 unless @user

    if @user.update_attributes( password_params )
      sign_in(@user)
      redirect_to user_profile_url(:username => @user.username)
    else
      flash[:error] = @user.errors.full_messages.first
      redirect_to recovery_url( :token => params[:token] )
    end
  end

  private

  def password_params
    params.require(:password).permit(:password, :password_confirmation)
  end
end
