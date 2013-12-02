class Event < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => :user_id

  belongs_to :source,   :foreign_key => :eventable_id
  belongs_to :user,     :foreign_key => :eventable_id  
  belongs_to :language, :foreign_key => :eventable_id    
  belongs_to :comment,  :foreign_key => :eventable_id

  TYPES = {
    :favorited        => 1,
    :registered       => 2,
    :sent_nth_content => 3,
    :commented        => 4,
    :logged_in        => 5,
    :views_reached    => 6,
    :follow_user      => 7,
    :follow_language  => 8
  }

  CONTENT_STEP = 5
  VIEWS_STEP = 3

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
    when TYPES[:logged_in]
      "logged_in"
    when TYPES[:views_reached]
      "views_reached"
    when TYPES[:follow_user]
      "follow_user"
    when TYPES[:follow_language]
      "follow_language"
    end
  end

  def self.new_favorited(user,source)
    unless source.private?  
      Event.create({
        owner: user,
        eventable_type: TYPES[:favorited],
        eventable_id: source.id
      })
    end
  end

  def self.new_registered(user)
    Event.create({
      owner: user,
      eventable_type: TYPES[:registered],
      eventable_id: user.id      
    })
  end

  def self.new_nth_content(user,source,counter)
    unless source.private?      
      Event.create({
        owner: user,
        eventable_type: TYPES[:sent_nth_content],
        eventable_id: source.id,
        data: counter
      })
    end
  end

  def self.new_comment(user,comment)
    Event.create({
      owner: user,
      eventable_type: TYPES[:commented],
      eventable_id: comment.id      
    })
  end

  def self.new_login(user)
    previous = Event.find_last_by_user_id_and_eventable_type( user.id, TYPES[:logged_in] )
    # save only login events for a given user every 8 hours
    if previous.nil? or ( Time.now - previous.created_at ) >= 28800
      Event.create({
        owner: user,
        eventable_type: TYPES[:logged_in],
        eventable_id: user.id      
      })
    end
  end

  def self.new_views_reached(source,views)
    unless source.private?      
      Event.create({
        owner: source.user,
        eventable_type: TYPES[:views_reached],
        eventable_id: source.id,
        data: views
      })
    end
  end

  def self.new_follow_user(user,who_id)
    Event.create({
      owner: user,
      eventable_type: TYPES[:follow_user],
      eventable_id: who_id
    })
  end

  def self.new_follow_language(user,language_id)
    Event.create({
      owner: user,
      eventable_type: TYPES[:follow_language],
      eventable_id: language_id
    })
  end

  def self.new_follow(user,follow_type,subject_id)
    if follow_type == Follow::TYPES[:user] 
      self.new_follow_user(user,subject_id)

    elsif follow_type == Follow::TYPES[:language]
      self.new_follow_language(user,subject_id)
    end
  end

end
