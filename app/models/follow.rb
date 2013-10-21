class Follow < ActiveRecord::Base
  belongs_to :user

  TYPES = {
    :user     => 1,
    :language => 2
  }

  validates_presence_of  :user_id, :follow_type, :follow_id
  validates_inclusion_of :follow_type, :in => TYPES.values.freeze  
  validate               :not_already_followed
  validate               :object_exists

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

end
