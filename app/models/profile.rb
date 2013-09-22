class Profile < ActiveRecord::Base
  include Rateable

  belongs_to :user
  has_many   :comments, -> { where :commentable_type => Comment::COMMENTABLE_TYPES[:profile] }, :foreign_key => :commentable_id

  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  validates_format_of :gplus,   :with => URI::regexp(%w(http https)), :allow_blank => true

  def path
    "/profile/#{user.username}"
  end

  def url
    "http://www.emoticode.net#{path}"
  end

  def commentable_type
    Comment::COMMENTABLE_TYPES[:profile]
  end
end

