class Profile < ActiveRecord::Base
  include Commentable
  include Rateable

  belongs_to :user
  
  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  validates_format_of :gplus,   :with => URI::regexp(%w(http https)), :allow_blank => true

  def path
    "/profile/#{user.username}"
  end

  def url
    "http://www.emoticode.net#{path}"
  end
end

