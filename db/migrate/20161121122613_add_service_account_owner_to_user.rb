class AddServiceAccountOwnerToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cronofy_service_account_owner, :string
  end
end
