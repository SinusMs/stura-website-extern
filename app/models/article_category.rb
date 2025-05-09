class ArticleCategory < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  attribute :enabled, :boolean, default: true

  scope :enabled, -> { where(enabled: true) }

  has_many :articles, dependent: :nullify
end
