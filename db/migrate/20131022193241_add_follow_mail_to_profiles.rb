class AddFollowMailToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :follow_mail, :boolean, :default => true
  end
end
