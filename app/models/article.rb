class Article < ApplicationRecord
  validates :title, :published, :content, :article_category_id, presence: true

  scope :public_articles, -> {
    joins(:article_category)
      .where(article_categories: { enabled: true })
      .where(published: (Setting.first.showArticlesForDays.days.ago..Time.now))
  }

  scope :order_by_date_and_priorization, -> { order(Arel.sql("CASE WHEN prioritize_until >= ? THEN 0 ELSE 1 END, published DESC", Time.now)) }

  belongs_to :article_category

  has_one_attached :image

  def prioritized?
    prioritize_until.present? && prioritize_until >= Time.now
  end
end
