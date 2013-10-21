class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :user, index: true
      t.integer :follow_type
      t.integer :follow_id

      t.timestamps
    end
  end
end
