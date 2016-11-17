class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :cronofy_account_id
      t.string :cronofy_access_token
      t.string :cronofy_refresh_token
      t.date :cronofy_access_token_expiration
      t.string :cronofy_domain

      t.timestamps
    end
  end
end
