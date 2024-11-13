json.extract! article, :id, :title, :published, :content, :article_category_id, :created_at, :updated_at
json.url article_url(article, format: :json)
