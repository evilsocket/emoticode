class FavoriteController < ApplicationController
  before_filter :authenticate!

  def make
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js { 
        favorite = Favorite.where( :user => @current_user ).where( :source_id => params[:id] ).first
        source = Source.find_by_id( params[:id] )

        if !favorite && source
          @favorite = Favorite.create( :user => @current_user, :source => source )
          @favorite.save!
        else
          redirect_to '/'
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js { 
        @favorite = Favorite.where( :user => @current_user ).where( :source_id => params[:id] ).first
        if @favorite
          @favorite.destroy!
        else
          redirect_to '/'
        end

      } 
    end
  end
end
