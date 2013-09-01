class FavoriteController < ApplicationController
  before_filter :authenticate!
  
  def make
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js { 
        @favorite = Favorite.new( :user => @current_user, :source_id => params[:id] )
        @favorite.save!
      }
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js { 
        @favorite = Favorite.where( :user => @current_user ).where( :source_id => params[:id] ).first
        @favorite.destroy!
      } 
    end
  end
end
