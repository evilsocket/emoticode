class AddCommentsCountToSources < ActiveRecord::Migration
  def change
    add_column :sources, :comments_count, :integer, :default => 0
  end
end
