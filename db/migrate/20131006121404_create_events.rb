class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.integer :type
      t.integer :eventable_type
      t.integer :eventable_id

      t.timestamps
    end
  end
end
