class AddSmartInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :smart_invites do |t|
      t.string :smart_invite_id
      t.string :email

      t.timestamps
    end
  end
end
