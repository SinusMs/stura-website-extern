class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: ENV.fetch("MINIMUM_USER_PASSWORD_LENGTH", 3).to_i }, unless: Proc.new { |user| user.password.nil? }
  validates :username, uniqueness: true, length: { minimum: 3 }, format: { with: /\A[0-9A-Za-z_\-.]*\z/, message: "darf nur Ziffern und Buchstaben enthalten" }
  validates :email_address, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "ungültig" }

  has_one :reset_password_code, class_name: "ResetPasswordCode", dependent: :destroy
end
