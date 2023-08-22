class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :user_id, :stock_id, presence: true
end
