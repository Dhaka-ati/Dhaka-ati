class InvitationKey < ApplicationRecord
  belongs_to :room

  before_create :generate_otp

  private

  def generate_otp
    self.key = loop do
      random_otp = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
      break random_otp unless InvitationKey.exists?(key: random_otp)
    end
  end
end
