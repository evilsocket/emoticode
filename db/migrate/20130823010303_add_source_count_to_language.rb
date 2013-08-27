class AddSourceCountToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :sources_count, :integer, :default => 0

    Language.reset_column_information
    Language.find_each do |language|
      Language.reset_counters language.id, :sources
    end
  end
end
