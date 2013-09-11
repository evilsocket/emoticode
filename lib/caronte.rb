require 'caronte/caronte'

module Caronte
  def self.check(name)
    Caronte::Resolver.check name
  end
end
