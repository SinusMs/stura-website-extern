require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  Rails.application.routes.default_url_options[:host] = "example.com"
  test "reset password" do
    user = users(:admin)
    reset_password_code = ResetPasswordCode.new(user: user, code: SecureRandom.alphanumeric(32), is_activation_code: false)
    mail = UserMailer.with(user: user, reset_password_code: reset_password_code).reset_password
    assert_equal mail.to, [ user.email_address ]
    assert_match Regexp.new(Rails.application.routes.url_helpers.reset_password_url(reset_password_code.code)), mail.html_part.body.decoded
    assert_match Regexp.new(Rails.application.routes.url_helpers.reset_password_url(reset_password_code.code)), mail.text_part.body.decoded
  end
end
