class User < ActiveRecord::Base
  scope :latest, :order => 'created_at DESC' 
  
  has_many :sources
  has_many :favorites
  has_many :authorizations
  has_one  :profile

  LEVELS   = { :admin => 1, 
               :editor => 2, 
               :subscriber => 3 
  }
  STATUSES = { :not_confirmed => 1, 
               :confirmed     => 2,
               :banned        => 3,
               :deleted       => 4
  }

  validates_uniqueness_of :username, :email
  validates_format_of     :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_inclusion_of  :level,    :in => LEVELS.values.freeze
  validates_inclusion_of  :status,   :in => STATUSES.values.freeze

  def self.random_salt
    (0...5).map{65.+(rand(25)).chr}.join
  end

  def self.hash_password( salt, password )
    Digest::MD5.hexdigest( salt.to_s + password.to_s ) 
  end

  def self.authenticate(who, password)
    find_by_sql([ 'SELECT * FROM users WHERE ( username = ? OR email = ? ) AND MD5( CONCAT( salt, ? ) ) = password_hash AND status = ? ', who, who, password, STATUSES[:confirmed] ]).first 
  end

  def self.omniauth(auth)
    # at least the email is required to sign in an existing user
    if auth && auth['info'] && auth['info']['email'] 
      user = User.find_by_email( auth['info']['email'] )

      # new incoming user ^_^ 
      if user.nil? 
        # we need the nickname now
        if auth['info']['nickname']

          email        = auth['info']['email']
          username     = auth['info']['nickname']
          tmp_password = (0...10).map{65.+(rand(25)).chr}.join    
          salt         = self.random_salt

          user = User.create({ 
            username: username, 
            email: email, 
            salt: salt,
            password_hash: self.hash_password( salt, tmp_password ),
            status: STATUSES[:confirmed], 
            level: LEVELS[:subscriber]
          })

          profile = Profile.create({ user: user })
          
          update_omniauth_profile( auth, user, profile )
        end
      # existing user
      else 
        # confirm user if not yet confirmed
        user.status = STATUSES[:confirmed]
        user.save

        update_omniauth_profile( auth, user, user.profile )
      end

      user
    end
  end

  def is_admin?
    level == LEVELS[:admin]
  end

  def favorite?(source)
    @favorites ||= favorites.all
    @favorites.each do |fav| 
      return true unless fav.source != source
    end
    false
  end

  def avatar
    if profile.avatar?
      "/assets/avatars/#{id}.png"
    else
      "/assets/avatars/default.png"
    end
  end

  def language_statistics
    total_hits = 0
    stats      = {}
  
    # loop by language instead of looping by source
    # since a user could have a huge number of entries,
    # but languages number is known ( and lower ).
    Language.all.each do |language|
      count = language.sources.where( :user_id => id ).count
      stats[language] ||= 0
      stats[language] +=  count
      total_hits += count
    end

    stats.each do |language,hits|
      if hits > 0  
        stats[language] = ( ( hits * 100.0 ) / total_hits ).round 1
      else
        stats.delete language
      end
    end

    stats.sort_by(&:last).reverse
  end

  private

  def self.update_omniauth_profile( auth, user, profile )
    # first of all, check if the user already has an authorization
    # with the given provider
    authorization = Authorization.find_by_provider_and_uid( auth["provider"], auth["uid"] )
    if authorization
      # update data 
      authorization.token  = auth['credentials']['token'] unless !auth['credentials'] or !auth['credentials']['token']
      authorization.handle = auth['info']['nickname'] unless !auth['info']['nickname'] 
      authorization.uid    = auth['uid']
      authorization.save!
    else
      # create the new authorization object
      authorization = Authorization.create({
        :provider => auth['provider'],
        :user_id  => user.id,
        :token    => ( auth['credentials'] && auth['credentials']['token'] ) ? auth['credentials']['token'] : nil,
        :handle   => auth['info']['nickname'] ? auth['info']['nickname'] : nil,
        :uid      => auth['uid']
      })
    end

    # if user still has no avatar, fetch it from auth info if available
    if profile.avatar == 0 && auth['info']['image']
      begin
        image_path = File.join Dir.pwd, "app/assets/images/avatars/#{user.id}.png"

        FastImage.resize( auth['info']['image'], 50, 50, :outfile => image_path )

        profile.avatar = 1
      rescue

      end

      profile.save!
    end
  end

end
