class UserMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    @signed_id = @user.password_reset_tokens.create.signed_id(expires_in: 20.minutes)

    mail to: @user.email, subject: "Reset your password"
  end

  def email_verification
    @user = params[:user]
    @signed_id = @user.email_verification_tokens.create.signed_id(expires_in: 2.days)

    mail to: @user.email, subject: "Registration pending approval, Verify your email"
  end

  def approval_notification
    @user = params[:user]
    mail(to: @user.email, subject: 'You have been approved!')
  end


end
