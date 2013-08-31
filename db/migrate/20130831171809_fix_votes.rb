class FixVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :timestamp, :created_at
    remove_column :votes, :user_ip
  end
end
