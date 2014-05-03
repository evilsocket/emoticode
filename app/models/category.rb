class Category < ActiveRecord::Base
  has_many :posts

  def self.cached
    Rails.cache.fetch "Category#cached", :expires_in => 24.hours do
      Category.order('name ASC').all
    end
  end
end
