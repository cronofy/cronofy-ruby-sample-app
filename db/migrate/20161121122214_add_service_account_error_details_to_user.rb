class AddServiceAccountErrorDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cronofy_service_account_error_key, :string
    add_column :users, :cronofy_service_account_error_description, :string
  end
end
