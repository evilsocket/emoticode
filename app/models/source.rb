class Source < ActiveRecord::Base
  belongs_to :language, :counter_cache => true
  belongs_to :user
  has_many   :links
  has_many   :tags, :through => :links
  has_many   :comments, 
    :foreign_key => :commentable_id, 
    :conditions => [ 'commentable_type = ?', Comment::COMMENTABLE_TYPES[:source] ]

  default_scope :order => "created_at DESC"
  scope :popular, :order => 'views DESC'

  self.per_page = 10

  def path
    "/#{language.name}/#{name}.html"
  end

  def url
    "http://www.emoticode.net#{path}"
  end

  def commentable_type
    Comment::COMMENTABLE_TYPES[:source]
  end

  def related( limit = 5 )
    Rails.cache.fetch "#{limit}_related_sources_of_#{id}", :expires_in => 24.hours do
      Source
      .where( 'sources.id != ?', id )
      .joins(:links)
      .where( 'links.tag_id IN ( ? )', links.map(&:tag_id) )
      .order( '( COUNT(links.id) * links.weight ) DESC' )
      .group( 'links.source_id, sources.name' )
      .limit( limit )
      .all
    end
  end
end
