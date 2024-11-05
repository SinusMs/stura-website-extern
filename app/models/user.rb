class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 3 }
  validates :username, length: { minimum: 3 }
end
