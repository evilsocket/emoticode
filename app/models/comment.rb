class Comment < ActiveRecord::Base
  COMMENTABLE_TYPES = {
    :source  => 1,
    :profile => 2
    # more to come :)
  }

  belongs_to :user
  belongs_to :source, 
    :foreign_key => :commentable_id, 
    :conditions => [ 'commentable_type = ?', COMMENTABLE_TYPES[:source] ]

  validates_presence_of  :commentable_id,   :user_id, :content
  validates_inclusion_of :commentable_type, :in => COMMENTABLE_TYPES.values.freeze
  validate               :commentable_exists
  validate               :parent_null_or_exists

  before_save            :parse_content
  
  # this is needed for nesting comments in ApplicationHelper
  def children
    @children ||= []
    @children
  end

  def url
    base = "http://www.emoticode.net"
    case commentable_type
    when COMMENTABLE_TYPES[:source]
      "#{base}#{Source.find( commentable_id ).path}#comments"
    when COMMENTABLE_TYPES[:profile]
      "#{base}#{Profile.find( commentable_id ).path}#comments" 
    end
  end

  def commentable_user
    case commentable_type
    when COMMENTABLE_TYPES[:source]
      Source.find( commentable_id ).user
    when COMMENTABLE_TYPES[:profile]
      Profile.find( commentable_id ).user 
    end
  end

  protected

  include ActionView::Helpers::SanitizeHelper

  def parse_content
    # trim, remove tags and encode entities
    self.content = sanitize( self.content.strip )
    # replace valid @username with profile links :)
    self.content = self.content.gsub /\@([a-z0-9\-_\.]+)/i do |m|
      m[0] = '' # remove @
      if User.find_by_username( m ).nil?
        "@#{m}"
      else
        "<a href=\"/profile/#{m}\" target=\"_blank\" title=\"#{m} profile\">@#{m}</a>"
      end
    end
  end

  # custom validators
  
  def commentable_exists
    begin

      if commentable_type == COMMENTABLE_TYPES[:source]
        Source.find( commentable_id )
      elsif commentable_type == COMMENTABLE_TYPES[:profile]
        Profile.find( commentable_id )
      else
        raise ActiveRecord::RecordNotFound
      end

    rescue ActiveRecord::RecordNotFound
      errors.add( :commentable_id, " references to an invalid object." )
      false
    end
  end

  def parent_null_or_exists
    begin
      Comment.find( parent_id ) unless parent_id.nil?
    rescue
      errors.add( :commentable_id, " references to an invalid object." )
      false
    end
  end

end
