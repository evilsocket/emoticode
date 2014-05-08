# see http://stackoverflow.com/questions/393395/how-to-call-expire-fragment-from-rails-observer-model
class ActiveRecord::Base
  def expire_fragment(*args)
    ActionController::Base.new.expire_fragment(*args)
  end
end
