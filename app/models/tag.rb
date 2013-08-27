class Tag < ActiveRecord::Base 
  has_many :links
  has_many :sources, :through => :links
  has_many :languages, :through => :sources

  scope :popular, :order => 'sources_count DESC'

  def frequency
    sources_count
  end
end
