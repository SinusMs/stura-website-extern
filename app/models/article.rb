class Article < ApplicationRecord
  scope :public_articles, -> {
    joins(:article_category)
      .where(article_categories: { enabled: true })
      .where(published: (Setting.first.showArticlesForDays.days.ago..Time.now))
  }

  scope :order_by_date_and_priorization, -> { order(Arel.sql("CASE WHEN prioritize_until >= ? THEN 0 ELSE 1 END, published DESC", Time.now)) }

  belongs_to :article_category
end
