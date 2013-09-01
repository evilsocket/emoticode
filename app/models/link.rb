class Link < ActiveRecord::Base
  belongs_to :tag, :counter_cache => :sources_count
  belongs_to :source
end


