module Legacy
  class User < Legacy::Base
    has_one :profile, :class_name => 'Legacy::Profile', :foreign_key => 'user_id'
  end
end
