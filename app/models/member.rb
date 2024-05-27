class Member < ApplicationRecord
  has_many :rooms
  has_many :users
end
