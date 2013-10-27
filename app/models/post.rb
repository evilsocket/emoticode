class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many   :comments, -> { where :commentable_type => Comment::COMMENTABLE_TYPES[:post] }, :foreign_key => :commentable_id

  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { :minimum => 5, :maximum => 255 }
  validates :body, presence: true, length: { :minimum => 25 }

  before_create :create_name # create unique cached slug

  def self.find_by_name_and_category_name!( name, c_name )
    Post
    .joins( :category )
    .where( :categories => { name: c_name } )
    .where( :posts   => { name: name } )
    .first!
  end

  def commentable_type
    Comment::COMMENTABLE_TYPES[:post]
  end

  def url
    "http://www.emoticode.net/blog/#{category.name}/#{name}.html"
  end

  include ActionView::Helpers::SanitizeHelper

  def description!( html = false )
    Rails.cache.fetch "post_#{id}_description!_#{html}_#{title}" do
      text = body

      require 'redcarpet'

      renderer   = Redcarpet::Render::HTML.new
      extensions = {
        :fenced_code_blocks => true,
        :autolink => true,
        :underline => true,
        :quote => true,
        :footnotes => true
      }
      redcarpet  = Redcarpet::Markdown.new(renderer, extensions)

      text = redcarpet.render text

      if html
        text
      else
        strip_tags text
      end
    end
  end

  def parse!
    Rails.cache.fetch "post_#{id}_parse!_#{updated_at}" do
      require 'redcarpet'

      renderer   = Redcarpet::Render::HTML.new
      extensions = {
        :fenced_code_blocks => true,
        :autolink => true,
        :underline => true,
        :quote => true,
        :footnotes => true
      }
      redcarpet  = Redcarpet::Markdown.new(renderer, extensions)
      redcarpet.render body
    end
  end

  private

  def create_name
    base_name = title.parameterize
    name = base_name
    counter = 2
    # even if the title is validate for its uniqueness, different
    # titles could be converted to the same slug due to transliterations,
    # therefore we have to make sure that the slug is unique too.
    while Post.find_by_name(name).nil? == false
      name = "#{base_name}-#{counter}"
      counter += 1
    end

    self.name = name
  end

end
