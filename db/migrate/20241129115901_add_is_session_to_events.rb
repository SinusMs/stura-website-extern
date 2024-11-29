class AddIsSessionToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :is_session, :boolean
  end
end
