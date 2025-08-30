class Article < ApplicationRecord
  belongs_to :article_category
  has_one_attached :image

  validates :title, :published, :content, :article_category_id, presence: true

  def published_day
    published&.to_date
  end
  def published_day=(value)
    if value.present?
      begin
        date = Date.parse(value.to_s)
      rescue ArgumentError
        errors.add(:published_day, "ist kein gültiges Datum")
      end
      if date
        # Keep existing time if present, otherwise midnight
        time = published&.strftime("%H:%M:%S") || "00:00:00"
        self.published = Time.zone.parse("#{date} #{time}")
      end
    else
      self.published = nil
    end
  end

  def published_time
    published&.strftime("%H:%M")
  end
  def published_time=(value)
    return if value.blank? && published.blank?

    date = published&.to_date || Date.current
    time = value.present? ? value : "00:00"
    self.published = Time.zone.parse("#{date} #{time}")
  end

  scope :public_articles, -> {
    joins(:article_category)
      .where(article_categories: { enabled: true })
      .where(published: (Setting.first.showArticlesForDays.days.ago..Time.current))
  }

  scope :order_by_date_and_priorization, -> { order(Arel.sql("CASE WHEN prioritize_until >= ? THEN 0 ELSE 1 END, published DESC", Date.current)) }

  def prioritized?
    prioritize_until.present? && prioritize_until >= Date.current
  end
end
