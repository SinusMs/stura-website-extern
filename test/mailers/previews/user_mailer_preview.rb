# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def activate
    user = User.new(username: "Nutzername", email_address: "email@example.com")
    activation_code = UserActivationCode.new(code: "ExampleActivationCode")
    UserMailer.with(user: user, activation_code: activation_code).activate
  end

  def reset_password_request
    user = User.new(username: "Nutzername", email_address: "email@example.com")
    reset_password_code = ResetPasswordCode.new(code: "ExampleActivationCode")
    UserMailer.with(user: user, reset_password_code: reset_password_code).reset_password_request
  end
end
