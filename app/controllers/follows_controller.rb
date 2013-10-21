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
