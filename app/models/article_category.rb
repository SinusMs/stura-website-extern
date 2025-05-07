class ArticleCategory < ApplicationRecord
  attribute :enabled, :boolean, default: true

  scope :enabled, -> { where(enabled: true) }

  has_many :articles, dependent: :nullify
end
