class Stock < ApplicationRecord
    has_many :transactions
    has_many :portfolios
    has_many :users, through: :portfolios

  validates :name, presence: true
  validates :symbol, presence: true, uniqueness: true
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

end
