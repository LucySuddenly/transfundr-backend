class MailerMailer < ApplicationMailer
    default from: "transfundr@gmail.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'You have a new donation!')
  end
end
