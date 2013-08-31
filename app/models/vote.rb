class Vote < ActiveRecord::Base 
  belongs_to :rating
  belongs_to :user

  validates :value, :numericality => { :greater_than => 0, :less_than_or_equal_to => 1.0 }, :presence => true
  validate :not_already_sent
  validate :not_voting_himself

  protected

  def not_voting_himself
    if rating.rateable_type == Rating::RATEABLE_TYPES[:user] and user.id == rating.rateable_id
      errors[:base] << "You can't vote yourself."      
      false
    else
      true
    end
  end

  def not_already_sent
    begin

      vote = Vote.find_by_rating_id_and_user_id( rating_id, user_id )
      unless vote.nil? or vote.id == id 
        errors[:base] << "Already voted."
        false
      end

    rescue ActiveRecord::RecordNotFound
      true
    end
  end


end

