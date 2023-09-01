module PortfoliosHelper

  def total_stocks_value(portfolios)
    portfolios.sum { |portfolio| portfolio.stock.current_price * portfolio.quantity }
  end

  def portfolios_empty?(portfolios)
    portfolios.empty?
  end
  
  def total_balance(user_balance, total_stocks_value)
    user_balance + total_stocks_value
  end
  
end
