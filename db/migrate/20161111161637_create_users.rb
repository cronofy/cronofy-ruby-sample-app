class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :cronofy_id
      t.string :email
      t.string :name
      t.string :timezone
      t.string :cronofy_access_token
      t.string :cronofy_refresh_token
      t.date :cronofy_access_token_expiration

      t.timestamps
    end
  end
end
