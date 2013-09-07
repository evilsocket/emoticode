module Legacy
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection :legacy_db
  end
end
