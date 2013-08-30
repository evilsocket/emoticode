class UserMailer < ActionMailer::Base
  default from: "noreply@emoticode.net"

  def confirmation_email(user,password)
    @user     = user
    @token    = user.confirmation_token
    @password = password

    mail( to: @user.email, subject: 'EmotiCODE Account Confirmation' )
  end

  def omniauth_confirmation_email(user,provider,password)
    @user     = user
    @provider = provider
    @password = password

    mail( to: @user.email, subject: 'Welcome to EmotiCODE' )
  end
end
