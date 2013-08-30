class Profile < ActiveRecord::Base
  belongs_to :user
  has_many   :comments, 
    :foreign_key => :commentable_id, 
    :conditions => [ 'commentable_type = ?', Comment::COMMENTABLE_TYPES[:profile] ]

  def commentable_type
    Comment::COMMENTABLE_TYPES[:profile]
  end

  def path
    "/profile/#{user.username}"
  end
end

