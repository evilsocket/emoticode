module Legacy
  class Profile < Legacy::Base
    belongs_to :user, :class_name => 'Legacy::User', :foreign_key => 'user_id'
  end
end

