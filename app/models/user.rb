class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 3 }, unless: Proc.new { |user| user.password.nil? }
  validates :username, uniqueness: true, length: { minimum: 3 }, format: { with: /\A[0-9A-Za-z_\-.]*\z/, message: "Use only numbers and letters for your Username!" }
  validates :email_address, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid" }

  has_one :reset_password_code, class_name: "ResetPasswordCode", dependent: :destroy
end
