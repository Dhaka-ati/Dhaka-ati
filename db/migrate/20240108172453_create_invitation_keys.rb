class CreateInvitationKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :invitation_keys do |t|
      t.string :key
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
