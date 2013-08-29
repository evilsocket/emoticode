class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true

  def url
    hostname = case provider
               when 'facebook'
                 'www.facebook.com'
               when 'github'
                 'www.github.com'
               else
                 'www.???.com'
               end   

    nickname = handle || uid

    "http://#{hostname}/#{nickname}"
  end
end
