class CommentsController < ApplicationController
  before_filter :authenticate!

  def create  
    respond_to do |format|
      format.js {
        @comment = Comment.new params.require(:comment).permit( :parent_id, :commentable_type, :commentable_id, :content )
        @comment.user_id = @current_user.id
        if @comment.save
          if @comment.parent_id.nil?
            UserMailer.comment_email( @current_user, @comment.commentable_user, @comment.url ).deliver
          else
            UserMailer.comment_reply_email( @current_user, @comment.commentable_user, @comment.url ).deliver
          end
        end
      }
    end
  end
end
