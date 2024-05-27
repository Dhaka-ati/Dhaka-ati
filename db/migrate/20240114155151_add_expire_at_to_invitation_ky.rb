class AddExpireAtToInvitationKy < ActiveRecord::Migration[7.1]
  def change
    add_column :invitation_keys, :expire_at, :datetime
  end
end
