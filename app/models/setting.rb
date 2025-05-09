class Setting < ApplicationRecord
  validates :showArticlesForDays, presence: true, comparison: { greater_than: 0 }
end
