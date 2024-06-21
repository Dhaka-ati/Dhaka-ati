class AddTwoFieldsToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :is_block, :boolean, default: false
    add_column :rooms, :description, :string
  end
end
