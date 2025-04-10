class CreateArticleCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :article_categories do |t|
      t.string :name
      t.boolean :enabled

      t.timestamps
    end

    create_table :articles do |t|
      t.string :title
      t.datetime :published
      t.text :content
      t.belongs_to :article_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
