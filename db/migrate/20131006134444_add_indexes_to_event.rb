class AddIndexesToEvent < ActiveRecord::Migration
  def change
    add_index :events, :eventable_id
    add_index :events, :created_at
  end
end
