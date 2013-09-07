module Legacy
  class Source < Legacy::Base
    belongs_to :language, :class_name => 'Legacy::Language', :foreign_key => 'language_id' 
    belongs_to :user, :class_name => 'Legacy::User', :foreign_key => 'author_id'
  end
end

