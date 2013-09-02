class Tag < ActiveRecord::Base 
  has_many :links
  has_many :sources, :through => :links
  has_many :languages, :through => :sources

  scope :popular,      -> { order('sources_count, weight DESC') }
  scope :with_sources, -> { joins(:sources).group('tags.id') }
  scope :for_language, lambda { |lang| with_sources.where('sources.language_id = ?', lang.id) }
  scope :longer,       -> { where('LENGTH(tags.value) >= 4') }

  def frequency
    sources_count
  end
end
