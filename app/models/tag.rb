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

  def self.cloud( language = nil, limit = 70, min_length = 4, exclude = [ 'css', 'html', 'javascript', 'actionscript', 'actionscript-3' ] )
    Rails.cache.fetch "Tag#cloud_#{language.nil? ? 'nil' : language.id}_#{limit}_#{min_length}_#{exclude.join '_'}", :expires_in => 1.week do 
      query = joins(:sources).
        group( 'tags.id' ).
        where( 'LENGTH(tags.value) >= ?', min_length ).
        order( 'sources_count DESC, weight DESC' ).
        limit( limit )

      if language.nil? 
        query.where( 'sources.language_id NOT IN ( SELECT id FROM languages WHERE name IN ( ? ) )', exclude ).to_a
      else
        query.where( 'sources.language_id = ?', language.id ).to_a
      end
    end
  end

end
