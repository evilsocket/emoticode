class AddWeeklyNewsletterToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :weekly_newsletter, :boolean, :default => true
  end
end
