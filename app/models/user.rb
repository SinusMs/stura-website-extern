class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 3 }
  validates :username, length: { minimum: 3 }, format: { with: /[0-9A-Za-z]/, message: "Use only numbers and letters for your Username!" }
end
