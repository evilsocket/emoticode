class Follow < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :user_id
  
  TYPES = {
    :user     => 1,
    :language => 2
  }
  
  belongs_to :user,     :foreign_key => :follow_id
  belongs_to :language, :foreign_key => :follow_id
  
  default_scope -> { order('created_at DESC') }  
  scope :by_type, -> { order('follow_type DESC') }
  
  validates_presence_of  :user_id, :follow_type, :follow_id
  validates_inclusion_of :follow_type, :in => TYPES.values.freeze  
  validate               :not_already_followed
  validate               :object_exists

  after_create  :invalidate_user_stream_cache
  after_destroy :invalidate_user_stream_cache

  def type_key
    if follow_type == TYPES[:user]
      :user
    elsif follow_type == TYPES[:language]
      :language
    end
  end

  def text
    begin
      if follow_type == TYPES[:user]
        User.find( follow_id ).username
      elsif follow_type == TYPES[:language]
        Language.find( follow_id ).title
      end
    rescue ActiveRecord::RecordNotFound
      "?"
    end
  end

  def object
    if follow_type == TYPES[:user]
      User.find( follow_id )
    elsif follow_type == TYPES[:language]
      Language.find( follow_id )
    end
  end 

  protected

  def not_already_followed
    begin
      if Follow.where( ['user_id = ? AND follow_type = ? AND follow_id = ?', user_id, follow_type, follow_id ] ).any?
        errors.add( :follow_id, "is already followed." ) 
        false
      end
    rescue ActiveRecord::RecordNotFound

    end
    true
  end

  def object_exists
    begin
      if follow_type == TYPES[:user]
        User.find( follow_id )
      elsif follow_type == TYPES[:language]
        Language.find( follow_id )
      end
    rescue ActiveRecord::RecordNotFound
      errors.add( :follow_id, "is not a valid object id." )
      false
    end
  end
  
  def invalidate_user_stream_cache
    (1..1000).each do |p|
      Rails.cache.delete "user_#{user_id}_stream_page_#{p}"
    end
  end
end
