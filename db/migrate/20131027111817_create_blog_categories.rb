class CreateBlogCategories < ActiveRecord::Migration
  def change
    Category.create :title => 'News', :name => 'news'
    Category.create :title => 'New Features', :name => 'new-features'
  end
end
