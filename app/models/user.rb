class User < ApplicationRecord
  has_secure_password
  has_many :api_tokens
  has_many :members
  has_one :room

  validates :email, uniqueness: { case_sensitive: false }
  # has_many :authorization_keys, as: :authable, dependent: :destroy
end
