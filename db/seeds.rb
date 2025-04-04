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
  puts "No admin account found, creating default admin account... "
  User.create!(username: ENV["DEFAULT_USER_USERNAME"], password: ENV["DEFAULT_USER_PASSWORD"], is_admin: true).username
  puts "Done!"
end

if ArticleCategory.where(name: "News").blank?
  ArticleCategory.create!(name: "News", enabled: true)
end

if ArticleCategory.where(name: "Stus Blog").blank?
  ArticleCategory.create!(name: "Stus Blog", enabled: true)
end

if Settings.first().blank?
  Settings.create!(showArticlesForDays: 180)
end
