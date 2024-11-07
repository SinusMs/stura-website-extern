class ContactEmailAddress < ApplicationRecord
  validates :name, uniqueness: true
end
