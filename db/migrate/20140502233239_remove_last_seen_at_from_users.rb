class RemoveLastSeenAtFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :last_seen_at    
  end
end
