class Source < ActiveRecord::Base
  belongs_to :language, :counter_cache => true
  belongs_to :user
  has_many   :links
  has_many   :tags, :through => :links
  
  default_scope :order => "created_at DESC"
  scope :popular, :order => 'views DESC'

  def path
    "/#{language.name}/#{name}.html"
  end

  def url
    "http://www.emoticode.net#{path}"
  end
end
