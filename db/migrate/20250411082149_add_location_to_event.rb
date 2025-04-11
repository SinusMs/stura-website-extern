class AddLocationToEvent < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :location, :string
  end
end
