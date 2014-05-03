class AddUserIdIndexToSources < ActiveRecord::Migration
  def change
    add_index :sources, :user_id
  end
end
