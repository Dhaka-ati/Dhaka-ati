class Room < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :invitation_keys, dependent: :destroy
end
