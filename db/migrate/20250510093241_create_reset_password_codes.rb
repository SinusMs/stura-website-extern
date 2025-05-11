class CreateResetPasswordCodes < ActiveRecord::Migration[7.2]
  def change
    create_table :reset_password_codes do |t|
      t.string :code
      t.boolean :is_activation_code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
