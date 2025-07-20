class ResetPasswordCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :user, presence: true

  belongs_to :user

  def expired?
    is_activation_code ?
      created_at < ENV.fetch("ACCOUNT_ACTIVATION_CODE_VALIDITY_DAYS").to_i.days.ago :
      created_at < ENV.fetch("RESET_PASSWORD_CODE_VALIDITY_MINUTES").to_i.minutes.ago
  end
end
