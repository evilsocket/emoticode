class Language < ActiveRecord::Base
  has_many :sources
  has_many :tags, :through => :links

  scope :popular, :order => 'sources_count DESC'
end
