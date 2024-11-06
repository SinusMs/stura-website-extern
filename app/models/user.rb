class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 3 }, unless: Proc.new { |user| user.password.nil? }
  validates :username, uniqueness: true, length: { minimum: 3 }, format: { with: /\A[0-9A-Za-z]\z/, message: "Use only numbers and letters for your Username!" }
end
