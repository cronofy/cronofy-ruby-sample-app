class AddCronofyIsServiceAccountTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cronofy_is_service_account_token, :boolean
  end
end
