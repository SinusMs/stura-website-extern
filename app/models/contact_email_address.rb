class ContactEmailAddress < ApplicationRecord
  validates :name, :email_address, presence: true
  validates :name, uniqueness: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid" }, confirmation: true
end
