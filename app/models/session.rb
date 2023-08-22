class Session < ApplicationRecord
  belongs_to :user

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end
  validates :user_id, presence: true
  validates :user_agent, :ip_address, presence: true
end
