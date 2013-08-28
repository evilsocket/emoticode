class Comment < ActiveRecord::Base
  OBJECT_TYPES = {
    :source  => 1,
    :profile => 2
    # more to come :)
  }

  belongs_to :user
  belongs_to :source, 
    :foreign_key => :object_id, 
    :conditions => [ 'object_type = ?', OBJECT_TYPES[:source] ]

  def children
    @children ||= []
    @children
  end

end
