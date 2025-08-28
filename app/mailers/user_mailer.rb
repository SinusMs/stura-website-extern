class UserMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @reset_password_code = params[:reset_password_code]
    mail(
      to: @user.email_address,
      subject: @reset_password_code.is_activation_code ? "Accountaktivierung - StuRa-Website HTW Dresden" : "Zurücksetzen deines Accounts - StuRa-Website HTW Dresden"
    )
  end
end
