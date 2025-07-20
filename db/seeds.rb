# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if User.where(is_admin: true).blank?
  puts "No admin account found, creating default admin account."
  User.create!(username: ENV.fetch("DEFAULT_USER_USERNAME"), password: ENV.fetch("DEFAULT_USER_PASSWORD"), email_address: ENV.fetch("DEFAULT_USER_EMAIL_ADDRESS"), is_admin: true).username
end

if ArticleCategory.where(name: "News").blank?
  puts "No News Category found, creating default News Category."
  ArticleCategory.create!(name: "News", enabled: true)
end

if Setting.first().blank?
  puts "No Settings found, creating default Settings."
  Setting.create!(showArticlesForDays: 180)
end
