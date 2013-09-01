class Comment < ActiveRecord::Base
  COMMENTABLE_TYPES = {
    :source  => 1,
    :profile => 2
    # more to come :)
  }

  COMMENTABLE_CLASSES = {
    1 => 'Source',
    2 => 'Profile'
  }

  belongs_to :user
  belongs_to :source, -> { where commentable_type: COMMENTABLE_TYPES[:source] }, :foreign_key => :commentable_id

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

  def commentable
    Kernel.const_get( COMMENTABLE_CLASSES[ commentable_type ] ).find( commentable_id )
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

      commentable

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
