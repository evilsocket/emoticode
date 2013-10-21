class FollowsController < ApplicationController
  before_filter :authenticate!
  
  def follow
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js {
        raise params.inspect
        # @favorite = Favorite.new( :user => @current_user, :source_id => params[:id] )
        # @favorite.save!
        # Event.new_favorited( @current_user, @favorite.source )

        Event.new_follow( @current_user, params[:type], params[:id] ) 
      }
    end
  end

  def unfollow

  end
end
