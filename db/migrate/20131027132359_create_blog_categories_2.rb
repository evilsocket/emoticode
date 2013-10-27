class CreateBlogCategories2 < ActiveRecord::Migration
  def change
    Category.create :title => 'Fixes', :name => 'fixes'    
  end
end
