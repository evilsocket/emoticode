class ProfileController < ApplicationController
  before_filter :authenticate!, :except => [:show, :badge]
  before_filter :admin!, only: [ :destroy, :ban, :unban ]  
  before_filter :skip_password_attribute, only: :update

  def show
    @user    = User.find_by_username!( params[:username] )
    @sources = @user.sources.where( :private => false ).paginate(:page => params[:page], :per_page => 8 )
    @comment = Comment.new
  end

  def snippets
    @sources = @current_user.sources.page( params[:page] )
  end

  def favorites
    @favorites = @current_user.favorites.joins(:source).order('sources.created_at DESC').page( params[:page] )
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

  def ban
    @user.status = User::STATUSES[:banned]
    @user.save!
    redirect_to user_profile_url :username => @user.username    
  end

  def unban
    @user.status = User::STATUSES[:confirmed]
    @user.save!
    redirect_to user_profile_url :username => @user.username    
  end

  def destroy
    # destroy all user content
    @user.sources.destroy_all
    # destroy all user events
    @user.events.destroy_all 
    # finally destroy the user
    @user.destroy

    redirect_to root_url
  end

  private

  def admin!
    @user = User.find( params[:id] )
    if @user.nil?
      render_404
    elsif @current_user.is_admin? == false
      render_404
    end
  end

  def user_params
    params.require(:user).permit(:username, :avatar_upload, :password, :password_confirmation, :profile_attributes => [ :aboutme, :website, :gplus, :weekly_newsletter, :follow_mail ])
  end

  def skip_password_attribute
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].except!(:password, :password_confirmation)
    end
  end
end
