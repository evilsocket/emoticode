module Legacy
  class Language < Legacy::Base
    belongs_to :source, :class_name => 'Legacy::Source', :foreign_key => 'language_id'
  end
end


