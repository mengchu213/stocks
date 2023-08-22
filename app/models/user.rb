class User < ApplicationRecord
  has_secure_password
  has_many :transactions
  has_many :portfolios
  has_many :stocks, through: :portfolios


  has_many :email_verification_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 6 }
  validates :role, presence: true, inclusion: { in: ['Trader', 'Admin'] }
  validates :status, presence: true, inclusion: { in: ['Approved', 'Pending'] }

  before_validation if: -> { email.present? } do
    self.email = email.downcase.strip
  end

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end
end
