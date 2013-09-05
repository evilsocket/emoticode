class AddSocializedToSources < ActiveRecord::Migration
  def change
    add_column :sources, :socialized, :boolean, :default => false
    Source.update_all :socialized => true
  end
end
