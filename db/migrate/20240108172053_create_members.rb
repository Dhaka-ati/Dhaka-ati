class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end