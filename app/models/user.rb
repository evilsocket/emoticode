class User < ActiveRecord::Base
  scope :latest, :order => 'created_at DESC' 
  
  has_many :sources
  has_many :favorites
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
          username     = auth['info']['nickname']
          tmp_password = (0...10).map{65.+(rand(25)).chr}.join    
          salt         = self.random_salt

          user = User.create({ 
            username: username, 
            email: email, 
            salt: salt,
            password_hash: self.hash_password( user.salt, tmp_password ),
            status: STATUSES[:confirmed], 
            level: LEVELS[:subscriber]
          })

          # TODO: Save token and avatar if available
          profile = Profile.create({ user: user })
        end
      # existing user
      else 
        # confirm user if not yet confirmed
        user.status = STATUSES[:confirmed]
        user.save

        # TODO: Refresh profile token
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
end
