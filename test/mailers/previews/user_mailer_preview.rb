# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def activate
    user = User.new(username: "Nutzername", email_address: "email@example.com")
    reset_password_code = ResetPasswordCode.new(code: "ExampleResetCode", is_activation_code: true)
    UserMailer.with(user: user, reset_password_code: reset_password_code).reset_password
  end

  def reset_password
    user = User.new(username: "Nutzername", email_address: "email@example.com")
    reset_password_code = ResetPasswordCode.new(code: "ExampleResetCode")
    UserMailer.with(user: user, reset_password_code: reset_password_code).reset_password
  end
end
