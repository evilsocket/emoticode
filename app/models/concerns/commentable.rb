module Commentable
  extend ActiveSupport::Concern

  included do
    CommentableType = Comment::COMMENTABLE_TYPES[ name.downcase.to_sym ]
    
    has_many :comments, -> { where :commentable_type => CommentableType }, :foreign_key => :commentable_id
  end

  def commentable_type
    CommentableType
  end
end
