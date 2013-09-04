class ProfileController < ApplicationController
  before_filter :authenticate!, :except => [:show, :badge]
  before_filter :skip_password_attribute, only: :update

  def show
    @user = User.find_by_username!( params[:username] )
    @comment = Comment.new
  end

  def badge
    @user = User.find_by_username!( params[:username] )
    render :layout => false
  end

  def edit
  end

  def update
    if @current_user.update_attributes( user_params )
      redirect_to user_profile_url(:username => @current_user.username)
    else
      flash[:error] = @current_user.errors.full_messages
      redirect_to user_settings_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :avatar_upload, :password, :password_confirmation, :profile_attributes => [ :aboutme, :website, :gplus ])
  end

  def skip_password_attribute
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].except!(:password, :password_confirmation)
    end
  end
end
