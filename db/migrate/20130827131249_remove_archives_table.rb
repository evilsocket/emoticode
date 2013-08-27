class RemoveArchivesTable < ActiveRecord::Migration
  def change
    drop_table :archives    
  end
end
