class Room < ApplicationRecord

  validates :title, uniqueness: true

  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :invitation_keys, dependent: :destroy
end
