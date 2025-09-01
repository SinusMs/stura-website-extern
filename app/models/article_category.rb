class ArticleCategory < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  attribute :enabled, :boolean, default: true

  scope :enabled, -> { where(enabled: true) }

  has_many :articles

  before_destroy :ensure_no_articles
  private
  def ensure_no_articles
    if articles.exists?
      errors.add(:base, "Kategorie kann nicht gelöscht werden, solange noch Artikel zugeordnet sind. Alternativ kann die Kategorie deaktiviert werden.")
      throw(:abort)
    end
  end
end
