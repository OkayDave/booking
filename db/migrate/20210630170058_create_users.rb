class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :api_token, default: '', null: false
      t.timestamps
    end

    add_index :users, :api_token
  end
end
