json.extract! event, :id, :datetime, :title, :description, :created_at, :updated_at
json.url event_url(event, format: :json)
