class Event < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :user_id

  belongs_to :source,  :foreign_key => :eventable_id
  belongs_to :user,    :foreign_key => :eventable_id  
  belongs_to :comment, :foreign_key => :eventable_id

  TYPES = {
    :favorited        => 1,
    :registered       => 2,
    :sent_nth_content => 3,
    :commented        => 4
  }

  CONTENT_STEP = 5

  def type_string
    case eventable_type
    when TYPES[:favorited]
      "favorited"
    when TYPES[:registered]
      "registered"
    when TYPES[:sent_nth_content]
      "sent_nth_content"
    when TYPES[:commented]
      "commented"
    end
  end

  def self.new_favorited(user,source)
    Event.create({
      owner: user,
      eventable_type: TYPES[:favorited],
      eventable_id: source.id
    })
  end

  def self.new_registered(user)
    Event.create({
      owner: user,
      eventable_type: TYPES[:registered],
      eventable_id: user.id      
    })
  end

  def self.new_nth_content(user,source,counter)
    Event.create({
      owner: user,
      eventable_type: TYPES[:sent_nth_content],
      eventable_id: source.id,
      data: counter
    })
  end

  def self.new_comment(user,comment)
    Event.create({
      owner: user,
      eventable_type: TYPES[:commented],
      eventable_id: comment.id      
    })
  end
end
