class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  

  validates :transaction_type, presence: true, inclusion: { in: ['buy', 'sell'], message: "must be either 'buy' or 'sell'" }
  validate :user_has_sufficient_funds, on: :create
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :stock_has_current_price

def stock_has_current_price
  if stock&.current_price.nil?
    errors.add(:base, "Stock doesn't have a current price")
  end
end

def user_has_sufficient_funds
  return unless user && stock&.current_price

  total_cost = stock.current_price * quantity
  user_balance = user.balance || 0.0
  
  if user_balance < total_cost
    errors.add(:base, "Insufficient funds")
  end
end


  
  
  
  def process_transaction
    if save # Assuming you're in the transaction model
      user.update(balance: user.balance - (stock.current_price * quantity))
    end
  end
end
