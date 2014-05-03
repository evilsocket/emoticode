class AddIndexToSources < ActiveRecord::Migration
  def change
    add_index :sources, :created_at    
    add_index :sources, :views
    add_index :sources, :private
  end
end
