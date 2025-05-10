class UserMailer < ApplicationMailer
  def activate
    @user = params[:user]
    @activation_code = params[:activation_code]
    mail(
      to: @user.email_address,
      from: "noreply@stura.htw-dresden.de",
      subject: "Accountaktivierung - StuRa-Website HTW Dresden",
      content_type: "text/html; charset=UTF-8"
    )
  end

  def reset_password_request
    @user = params[:user]
    @reset_password_code = params[:reset_password_code]
    mail(
      to: @user.email_address,
      from: "noreply@stura.htw-dresden.de",
      subject: "Zurücksetzen deines Accounts - StuRa-Website HTW Dresden",
      content_type: "text/html; charset=UTF-8"
    )
  end
end
