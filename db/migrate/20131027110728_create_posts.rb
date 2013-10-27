class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.references :category, index: true
      t.string :title
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
