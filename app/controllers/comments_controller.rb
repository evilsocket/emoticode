class CommentsController < ApplicationController
  before_filter :authenticate!

  def create 
    # TODO: Mailer!
    
    respond_to do |format|
      format.js {
        @comment = Comment.new params.require(:comment).permit( :parent_id, :commentable_type, :commentable_id, :content )

        @comment.user_id = @current_user.id
        @comment.save
      }
    end
  end
end
