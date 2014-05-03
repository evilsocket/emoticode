class AddIndexToFollows < ActiveRecord::Migration
  def change
    add_index :follows, :follow_id
    add_index :follows, :follow_type
  end
end
