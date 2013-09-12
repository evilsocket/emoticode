class AlertMailer < ActionMailer::Base
  default from: "alert@emoticode.net"
  default to: "evilsocket@gmail.com"

  def spammer_alert_email(params, request)
    @params = params
    @request = request

    mail( subject: 'EmotiCODE Spammer Alert' )
  end
end

