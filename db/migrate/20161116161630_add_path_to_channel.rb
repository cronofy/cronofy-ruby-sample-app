class AddPathToChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :channels, :path, :string
  end
end
