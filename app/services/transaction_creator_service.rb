class TransactionCreatorService
  def initialize(user, stock, transaction_params)
    @user = user
    @stock = stock
    @transaction_params = transaction_params
  end

  def call
    @user.transactions.new(@transaction_params.merge(stock_id: @stock.id, timestamp: Time.now))
  end
end
