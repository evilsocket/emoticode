class FollowsController < ApplicationController
  before_filter :authenticate!

  def follow
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js {
        @follow = Follow.new({
          :owner => @current_user,
          :follow_type => params[:type],
          :follow_id => params[:id]
        })
        @follow.save!

        Event.new_follow( @current_user, params[:type].to_i, params[:id].to_i ) 

        if params[:type].to_i == Follow::TYPES[:user]
          followed = User.find( params[:id] )
          if followed.profile.follow_mail?
            FollowMailer.follow( followed, @current_user ).deliver     
          end
        end
      }
    end
  end

  def unfollow
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js { 
        @follow = Follow.where( :owner => @current_user ).where( :follow_type => params[:type] ).where( :follow_id => params[:id] ).first
        @follow.destroy!
      } 
    end
  end
end
