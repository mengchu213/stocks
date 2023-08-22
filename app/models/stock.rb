class Stock < ApplicationRecord
  has_many :portfolios
  has_many :transactions
  
  validates :name, :symbol, presence: true
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

end
