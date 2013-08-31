class VotesController < ApplicationController
  before_filter :authenticate!

  def create
    respond_to do |format|
      format.js {
        @vote = Rating.add_vote_by_params @current_user, vote_params
      }
    end
  end

  private

  def vote_params
    params.require(:vote).permit( :rating_id, :vote )
  end
end
