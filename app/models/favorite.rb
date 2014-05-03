class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :source

  validates_presence_of :user_id, :source_id
  validate              :not_already_favorite
  validate              :source_exists

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  protected

  def not_already_favorite
    begin
      if Favorite.where( ['user_id = ? AND source_id = ?', user_id, source_id] ).any?
        errors.add( :source_id, "is already favorited." ) 
        false
      end
    rescue ActiveRecord::RecordNotFound

    end
    true
  end

  def source_exists
    begin
      Source.find( source_id )
    rescue ActiveRecord::RecordNotFound
      errors.add( :source_id, "is not a valid source id." )
      false
    end
  end

  def increment_counter_cache
    Source.increment_counter( 'favorites_count', source_id )
  end

  def decrement_counter_cache
    Source.decrement_counter( 'favorites_count', source_id )
  end

end
