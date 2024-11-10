class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.datetime :datetime
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
