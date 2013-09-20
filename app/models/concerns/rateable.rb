module Rateable
  extend ActiveSupport::Concern

  included do
    RateableType = Rating::RATEABLE_TYPES[ name.downcase.to_sym ]
    
    has_one :rating, -> { where rateable_type: RateableType }, :foreign_key => :rateable_id
  end
end

