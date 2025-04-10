class AddPrioritizeUntilToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :prioritize_until, :date
  end
end
