class ResetPasswordCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :user, presence: true

  belongs_to :user
end
