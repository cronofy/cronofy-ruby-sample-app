class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.text :last_body
      t.datetime :last_called

      t.timestamps
    end
  end
end
