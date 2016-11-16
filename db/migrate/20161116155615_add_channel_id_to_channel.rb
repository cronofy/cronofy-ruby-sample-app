class AddChannelIdToChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :channels, :channel_id, :string
  end
end
