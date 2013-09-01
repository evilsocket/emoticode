class Profile < ActiveRecord::Base
  belongs_to :user
  has_many   :comments, -> { where commentable_type: Comment::COMMENTABLE_TYPES[:profile] }, :foreign_key => :commentable_id
  has_one    :rating, -> { where rateable_type: Rating::RATEABLE_TYPES[:profile] }, :foreign_key => :rateable_id
  
  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  validates_format_of :gplus,   :with => URI::regexp(%w(http https)), :allow_blank => true

  def commentable_type
    Comment::COMMENTABLE_TYPES[:profile]
  end

  def path
    "/profile/#{user.username}"
  end

  def url
    "http://www.emoticode.net#{path}"
  end
end

