class AddEmailAddressToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :email_address, :string
  end
end
