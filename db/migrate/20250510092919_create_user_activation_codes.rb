class CreateUserActivationCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :user_activation_codes do |t|
      t.string :code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
