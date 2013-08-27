class Link < ActiveRecord::Base
  belongs_to :tag, :counter_cache => true
  belongs_to :source
end


