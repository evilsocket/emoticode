require 'fileutils'

namespace :legacy do
  desc "Import the legacy database sources and users"
  task migrate: :environment do
    LEGACY_AVATARS_PATH = '/var/www/emoticode.net/www/assets/avatars'
    RAILS_AVATARS_PATH  = '/var/www/emoticode.net/rails/shared/public/avatars'

    # User Migration
    Legacy::User.where(:status => 2).order('created_at DESC').each do |lu|
      break unless User.find_by_username(lu.username).nil?

      ActiveRecord::Base.transaction do
        puts "Importing #{lu.username} ..."

        user = User.new
        user.validations_to_skip = ['password']
        user.username = lu.username
        user.email = lu.email
        user.status = User::STATUSES[:confirmed]
        user.level = User::LEVELS[:subscriber]
        user.password_hash = lu.hashed
        user.salt = lu.salt
        user.created_at = lu.created_at
        user.last_seen_at = lu.last_seen_at
        user.save!

        puts "  Creating profile ..."

        profile = Profile.create({ 
          user_id: user.id,
          aboutme: lu.profile.aboutme,
          website: lu.profile.website,
          gplus: lu.profile.gplus,
          avatar: lu.profile.avatar
        }) 

        raise profile.errors.full_messages.inspect unless profile.valid?
        
        if lu.profile.fb_user_id
          puts "  Importing Facebook connection ..."

          auth = Authorization.create({
            user_id: user.id,
            provider: 'facebook',
            uid: lu.profile.fb_user_id,
            token: lu.profile.fb_access_token
          })

          raise auth.errors.full_messages.inspect unless auth.valid?
          
        end

        if lu.profile.avatar
          puts "  Copying avatar file ..."

          begin
            FileUtils.cp "#{LEGACY_AVATARS_PATH}/#{lu.id}.png", "#{RAILS_AVATARS_PATH}/new_id.png"
          rescue Exception => e
            puts "  ERROR: #{e.message}"
          end
        end
      end
    end

    # Sources migration
    Legacy::Source.order('created_at DESC').each do |ls|
      break unless Source.find_by_name(ls.name).nil?
      
      ActiveRecord::Base.transaction do
        language = Language.find_by_name ls.language.name
        user = User.find_by_username ls.user.username

        puts "Importing #{ls.title} by #{user.username} inside #{language.title} ..."

        source = Source.create({
          created_at: ls.created_at,
          language_id: language.id,
          user_id: user.id,
          views: ls.views,
          title: ls.title, 
          private: ls.private, 
          description: ls.description, 
          text: ls.text
        })

        raise source.errors.full_messages.inspect unless source.valid?      

      end
    end
  end
end
