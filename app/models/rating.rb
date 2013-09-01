class Rating < ActiveRecord::Base
  RATEABLE_TYPES = {
    :source  => 1,
    :user => 2
    # more to come :)
  }

  RATEABLE_CLASSES = {
    1 => 'Source',
    2 => 'User'
  }

  belongs_to :source,  -> { where rateable_type: RATEABLE_TYPES[:source] }, :foreign_key => :rateable_id
  belongs_to :profile, -> { where rateable_type: RATEABLE_TYPES[:profile] }, :foreign_key => :rateable_id

  validates_presence_of  :rateable_id
  validates_inclusion_of :rateable_type, :in => RATEABLE_TYPES.values.freeze
  validate               :rateable_exists

  def rateable
    Kernel.const_get( RATEABLE_CLASSES[ rateable_type ] ).find( rateable_id )
  end

  def already_voted_by?( user )
    !Vote.find_by_rating_id_and_user_id( id, user.id ).nil?
  end

  def self.add_vote_by_params(user,params)
    vote = Vote.new
    begin
      rating = Rating.find( params[:rating_id] )
      # normalize vote
      max     = 5
      normalized  = ( 100.0 * params[:vote].to_i ) / max
      normalized /= 100.0

      # create the vote
      vote.rating_id = rating.id
      vote.user_id   = user.id
      vote.value     = normalized
      vote.save

      # finally update the rating
      if vote.valid? 
        rating.average = ( ( rating.average * rating.votes ) + normalized ) / ( rating.votes + 1 )
        rating.votes  += 1
        rating.save
      end
    rescue
      vote.errors[:base] << "Generic error."
    end
    vote
  end 

  protected

  # custom validators
  
  def rateable_exists
    begin

      rateable

    rescue ActiveRecord::RecordNotFound
      errors.add( :rateable_id, " references to an invalid object." )
      false
    end
  end

end

