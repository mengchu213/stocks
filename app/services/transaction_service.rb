class TransactionService
  def initialize(user, transaction)
    @user = user
    @transaction = transaction
  end

  def process
    stock_price = @transaction.stock.current_price
    total_cost = stock_price * @transaction.quantity
  
    ActiveRecord::Base.transaction do
      if @transaction.transaction_type == 'buy'
        # Deduct from user's balance
        update_user_balance(-total_cost)
        # Adjust portfolio
        adjust_portfolio(@transaction.quantity)
      else # sell
        # Adjust portfolio first
        adjust_portfolio(-@transaction.quantity)
        # Add to user's balance
        update_user_balance(total_cost)
      end
    end
  
    { success: true, message: "Transaction completed successfully." }
  rescue ActiveRecord::Rollback => e
    { success: false, message: e.message }
  end
  

  def update_user_balance(amount)
    if (@user.balance + amount) < 0
      raise ActiveRecord::Rollback, "Transaction failed: Insufficient funds"
    end
  
    @user.balance += amount
    unless @user.save
      raise ActiveRecord::Rollback, "Transaction failed: Error updating user balance"
    end
  end
  

  private

  def adjust_portfolio(quantity)
    portfolio = @user.portfolios.find_or_initialize_by(stock_id: @transaction.stock_id)
    portfolio.quantity = portfolio.quantity.to_i + quantity
  
    # Check if there are negative stocks after selling
    if portfolio.quantity < 0
      raise ActiveRecord::Rollback, "Transaction failed: Not enough stocks to sell"
    end
  
    if portfolio.quantity.zero?
      portfolio.destroy!
    else
      portfolio.save!
    end
  end
  
end
