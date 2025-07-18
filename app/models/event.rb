class Event < ApplicationRecord
  validates :datetime, :title, presence: true
end
