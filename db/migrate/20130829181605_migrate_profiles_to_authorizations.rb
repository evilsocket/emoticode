class MigrateProfilesToAuthorizations < ActiveRecord::Migration
  def change
    Profile.find_each do |profile|
      unless profile.fb_user_id.nil?
        puts "Migrating #{profile.user.username} facebook profile ..."
        Authorization.create({
          :provider => 'facebook',
          :uid      => profile.fb_user_id,
          :token    => profile.fb_access_token,
          :user_id  => profile.user_id
        })
      end
    end 

    remove_column :profiles, :fb_user_id
    remove_column :profiles, :fb_access_token
    remove_column :profiles, :github
  end
end
