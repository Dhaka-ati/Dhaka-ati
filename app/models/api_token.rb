# app/models/api_token.rb
class ApiToken < ApplicationRecord
  belongs_to :user
  # belongs_to :updated_by, polymorphic: true, optional: true
  # belongs_to :created_by, polymorphic: true, optional: true

  validate :generate_access_token, on: :create

  def generate_access_token
    self.expired_at = 1.month.from_now
    self.token = BCrypt::Password.create(SecureRandom.hex(10))
  end
end
