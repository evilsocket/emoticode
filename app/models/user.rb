class User < ActiveRecord::Base
  scope :latest, -> { order('created_at DESC') }

  has_many :sources
  has_many :favorites
  has_many :authorizations
  has_one  :profile

  LEVELS   = { :admin => 1,
               :editor => 2,
               :subscriber => 3
  }
  STATUSES = { :unconfirmed => 1,
               :confirmed   => 2,
               :banned      => 3,
               :deleted     => 4
  }

  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
    uniqueness: { case_sensitive: false }

  validates :username, presence: true,
    format: { with: Patterns::ROUTE_PATTERN },
    uniqueness: { case_sensitive: false },
    length: { :minimum => 4, :maximum => 255 }

  validates :password, presence: { :on => :create },
    length: { :minimum => 5, :maximum => 255, :allow_nil => true },
    confirmation: true,
    :unless => "!validations_to_skip.nil? and validations_to_skip.include?('password')"

  validates_inclusion_of :level,  :in => LEVELS.values.freeze
  validates_inclusion_of :status, :in => STATUSES.values.freeze

  validates_associated          :profile
  accepts_nested_attributes_for :profile, update_only: true

  attr_accessor :password, :password_confirmation, :avatar_upload, :validations_to_skip

  before_create :create_salt
  before_create :create_hashed_password
  before_update :update_hashed_password
  before_update :update_avatar

  def self.authenticate(who, password)
    find_by_sql([ 'SELECT * FROM users WHERE ( username = ? OR email = ? ) AND MD5( CONCAT( salt, ? ) ) = password_hash AND status = ? ', who, who, password, STATUSES[:confirmed] ]).first
  end

  def self.find_by_confirmation_token( token )
    self.where( 'MD5( CONCAT( id, email, username, salt, password_hash ) )  = ?', token ).first
  end

  def self.get_random_password( length = 8 )
    (0...length).map{65.+(rand(25)).chr}.join
  end

  def self.activate(token)
    # search user by token
    user = self.find_by_confirmation_token(token)
    unless user.nil?
      # should be unconfirmed yet
      if user.status == STATUSES[:unconfirmed]
        user.status = STATUSES[:confirmed]
        user.save!
      else
        user = nil
      end
    end
    user
  end

  def self.omniauth(auth)
    # at least the email is required to sign in an existing user
    info = auth['info']
    if auth && info && info['email']
      user         = User.find_by_email( info['email'] )
      tmp_password = nil
      profile      = nil

      # new incoming user ^_^
      if user.nil?
        # we need the nickname now
        if info['nickname']
          # generate a temporary password
          tmp_password = self.get_random_password

          counter  = 2
          nickname = info['nickname'].parameterize
          while User.find_by_username(nickname).nil? == false
            nickname = "#{info['nickname']}-#{counter}"
            counter += 1
          end

          user = User.create({
            username: nickname,
            email: info['email'],
            password: tmp_password,
            password_confirmation: tmp_password,
            status: STATUSES[:confirmed],
            level: LEVELS[:subscriber]
          })

          profile = Profile.create({ user: user }) unless !user.valid?
        end
        # existing user
      else
        # confirm user if not yet confirmed
        user.status = STATUSES[:confirmed]
        user.save

        profile = user.profile
      end

      update_omniauth_profile( auth, user, profile ) unless profile.nil?

      [ user, tmp_password ]
    end
  end

  def favorite_by_others
    Favorite.joins(:source).where('sources.user_id = ?', self.id ).count
  end

  def is_admin?
    level == LEVELS[:admin]
  end

  def is_banned?
    status == STATUSES[:banned]
  end

  def is_connected?(provider)
    authorizations.where(:provider => provider).any?
  end

  def confirmation_token
    Digest::MD5.hexdigest( "#{id}#{email}#{username}#{salt}#{password_hash}" )
  end

  def rating
    Rating.find_or_create_by( :rateable_type => Rating::RATEABLE_TYPES[:user], :rateable_id => id )
  end

  def favorite?(source)
    Favorite.where( :user_id => self.id, :source_id => source.id ).any?
  end

  def avatar
    if profile.avatar?
      "/avatars/#{id}.png"
    else
      "/avatars/default.png"
    end
  end

  def language_statistics
    Rails.cache.fetch "user_#{self.id}_stats_#{self.sources.count}" do
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
  end

  private

  def create_salt
    self.salt = (0...5).map{65.+(rand(25)).chr}.join
  end

  def create_hashed_password
    unless self.password.nil?
      self.password_hash = Digest::MD5.hexdigest( self.salt + self.password )
    end
  end

  def update_hashed_password
    unless self.password.nil?
      self.password_hash = Digest::MD5.hexdigest( self.salt + self.password )
    end
  end

  def set_avatar_file(file)
    path = File.join Dir.pwd, "public/avatars/#{id}.png"

    FastImage.resize( file, 50, 50, :outfile => path )

    profile.avatar = 1
  end

  def update_avatar
    unless self.avatar_upload.nil?
      begin
        set_avatar_file avatar_upload.tempfile
      rescue
        self.errors.add( :avatar_upload, " not a valid image file." )
        false
      end
    end
  end

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

    begin
      # use default facebook graph avatar if not available from auth info
      if auth['provider'] == 'facebook'
        auth['info']['image'] ||= "http://graph.facebook.com/#{auth['uid']}/picture?type=large"
      end
    rescue; end

    # if user still has no avatar, fetch it from auth info if available
    if profile.avatar == 0 && auth['info']['image']
      begin
        user.send :set_avatar_file, auth['info']['image']
      rescue

      end

      profile.save!
    end
  end

end
