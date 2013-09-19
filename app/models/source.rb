class Source < ActiveRecord::Base
  belongs_to :language, :counter_cache => true
  belongs_to :user
  has_many   :links
  has_many   :tags, :through => :links
  has_many   :comments, -> { where commentable_type: Comment::COMMENTABLE_TYPES[:source] }, :foreign_key => :commentable_id
  has_one    :rating, -> { where rateable_type: Rating::RATEABLE_TYPES[:source] }, :foreign_key => :rateable_id

  default_scope -> { order('created_at DESC') }

  scope :public,     -> { where( :private => false ) }
  scope :popular,    -> { order('views DESC') }
  scope :by_links,   -> { order( '( COUNT(links.id) * links.weight ) DESC' ).group( 'links.source_id, sources.name' ) }
  scope :by_trend,   -> { select( 'sources.*, ( sources.views / ( ( UNIX_TIMESTAMP() - sources.created_at ) / 86400 ) ) AS trend' ).order('trend DESC') }
  scope :newer_than, ->(period) { where( 'created_at >= ?', period ) }

  scope :with_user_profile, -> { joins(:user => :profile) }
  scope :with_similar_links, ->(source) {
      where( 'sources.id != ?', source.id )
      .joins(:links)
      .where( 'links.tag_id IN ( ? )', source.links.map(&:tag_id) )
      .by_links
  }

  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { :minimum => 5, :maximum => 255 }
  validates :text, presence: true, length: { :minimum => 25 }
  validate :language_id_exists

  before_create :create_name       # create unique cached slug
  after_save    :lexical_analysis! # extract keywords and their weights
  after_save    :invalidate_highlight_cache!

  self.per_page = 10

  def path
    "/#{language.name}/#{name}.html"
  end

  def url
    "http://www.emoticode.net#{path}"
  end

  def short_url
    "http://www.emoticode.net/source/#{id}"    
  end

  def description!( default = nil )
    if !description.nil? && !description.empty?
      description
    else
      default || title
    end
  end

  def commentable_type
    Comment::COMMENTABLE_TYPES[:source]
  end

  def related( limit = 5 )
    Rails.cache.fetch "#{limit}_related_sources_of_#{id}", :expires_in => 24.hours do
      Source.with_similar_links(self).limit( limit ).load
    end
  end

  # normal find_each does not use given order but uses id asc
  def self.find_each_with_order(options={})
    raise "offset is not yet supported" if options[:offset]

    page = 1
    limit = options[:limit] || 1000

    loop do
      offset = (page-1) * limit
      batch = find(:all, options.merge(:limit=>limit, :offset=>offset))
      page += 1

      batch.each{|x| yield x }

      break if batch.size < limit
    end
  end

  def self.find_by_name_and_language_name!( name, language_name )
    Source
      .joins( :language )
      .where( :languages => { name: language_name } )
      .where( :sources   => { name: name } )
      .first!
  end

  private

  def create_name
    base_name = title.parameterize
    name = base_name
    counter = 2
    # even if the title is validate for its uniqueness, different
    # titles could be converted to the same slug due to transliterations,
    # therefore we have to make sure that the slug is unique too.
    while Source.find_by_name(name).nil? == false
      name = "#{base_name}-#{counter}"
      counter += 1
    end

    self.name = name
  end

  def tokenize
    # extract meaningful identifiers of at least 4 characters and at most 50, with a css 
    # class starting with a 'n' or a 'v'.
    # ( pygments/token.py )
    Albino
    .colorize( text, language.syntax )
    .scan( /<span\s+class="[nv][^"]*">([^<]{4,50})<\/span>/im )
    .map(&:first)
    # remove tokens when they are formed by a repetition ( ex. 'aaaaaaaaaa' or '___' )    
    .reject { |token| token.gsub( token[0], '' ).empty? }
  end

  def analyze
    analysis  = {}
    base      = 0.5
    tokens    = tokenize
    lowerized = tokens.map { |token| token.downcase }
    # build the analysis map where each token weight
    # is given by the formula:
    #
    #   base_weight + 0.3 * ( occurrences(token) - 1 )
    tokens.each do |token|
      analysis[token] ||= base * 0.3 * lowerized.count( token.downcase ) 
    end

    analysis
  end

  def lexical_analysis!    
    # save tokenization db
    self.send(:analyze).each do |token,weight|
      tag_name = token.parameterize
      # create the tag if it doesn't exist yet
      tag = Tag.find_by_name(tag_name) || Tag.create( :name => tag_name, :value => token )
      # create a link with this source if not already present
      link = Link.find_by_source_id_and_tag_id( id, tag.id ) || 
             Link.create( :source_id => id, :tag_id => tag.id, :weight => weight )
    end 
  end

  def invalidate_highlight_cache!
    Rails.cache.delete "highlighted_source_#{id}"
  end

  # validators

  def language_id_exists
    begin
      Language.find( language_id )
    rescue ActiveRecord::RecordNotFound
      errors.add( :language_id, "is not a valid language id." )
      false
    end
  end
end
