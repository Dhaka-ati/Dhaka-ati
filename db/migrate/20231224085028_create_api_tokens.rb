class CreateApiTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :api_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.text :token, null: false
      t.boolean :active, default: true
      t.datetime :expired_at
      t.bigint :created_by_id
      t.bigint :updated_by_id
      t.string :created_by_type
      t.string :updated_by_type

      t.timestamps
    end
  end
end
