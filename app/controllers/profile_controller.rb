class ProfileController < ApplicationController
  def show
    @user = User.find_by_username!( params[:username] )
    @comment = Comment.new
  end
end
