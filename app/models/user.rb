class User < ActiveRecord::Base
  scope :latest, :order => 'created_at DESC' 
  
  LEVELS   = { :admin => 1, 
               :editor => 2, 
               :subscriber => 3 
  }
  STATUSES = { :not_confirmed => 1, 
               :confirmed     => 2,
               :banned        => 3,
               :deleted       => 4
  }

  validates_inclusion_of :level, :in => LEVELS
  validates_inclusion_of :status, :in => STATUSES

  has_many :sources
  has_many :favorites
  has_one :profile

  def self.authenticate(who, password)
    find_by_sql([ 'SELECT * FROM users WHERE ( username = ? OR email = ? ) AND MD5( CONCAT( salt, ? ) ) = password_hash AND status = ? ', who, who, password, STATUSES[:confirmed] ]).first 
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
