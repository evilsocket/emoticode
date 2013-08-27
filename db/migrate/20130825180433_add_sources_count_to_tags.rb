class AddSourcesCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :sources_count, :integer, :default => 0

    Tag.reset_column_information
    Tag.find_each do |tag|
      tag.sources_count = tag.links.count
      tag.save
    end
  end
end
