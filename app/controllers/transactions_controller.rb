class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions
  def index
    @user = User.find(params[:user_id])
    @transactions = @user.transactions.order(created_at: :desc)
  end
  

  # GET /transactions/1
  def show
  end

  # GET /transactions/new
  def new
    @stock_symbol = params[:stock_symbol]
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
  end
  
  

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  def create
    stock = Stock.find_by(symbol: params[:stock_symbol].upcase) # Ensure it's uppercase since stock symbols are generally uppercase.
  
    unless stock
      fetched_stock_data = fetch_stock_from_external_source(params[:stock_symbol].upcase)
      unless fetched_stock_data
        flash[:alert] = "Stock with symbol #{params[:stock_symbol]} could not be fetched."
        redirect_to new_transaction_path and return
      end
      
      stock = Stock.create(
        name: fetched_stock_data[:name], 
        symbol: fetched_stock_data[:symbol],
        current_price: fetched_stock_data[:current_price]
      )
      
      unless stock.valid?
        flash[:alert] = "Failed to save fetched stock data: #{stock.errors.full_messages.join(", ")}"
        redirect_to new_transaction_path and return
      end
    end
    
    @transaction = Current.user.transactions.new(transaction_params.merge(stock_id: stock.id, timestamp: Time.now))
  
    if @transaction.save
      result = TransactionService.new(Current.user, @transaction).process
      if result[:success]
        redirect_to stocks_path, notice: result[:message]
      else
        flash[:alert] = result[:message]
        render :new
      end
    else
      flash[:alert] = @transaction.errors.full_messages.join(", ")
      @stock_symbol = params[:stock_symbol]
      render :new
    end
  end

  
  

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:transaction_type, :quantity, :user_id, :stock_id)
    end

    def fetch_stock_from_external_source(symbol)
      response = HTTParty.get("http://phisix-api.appspot.com/stocks/#{symbol}.json")
    
      Rails.logger.debug "Phisix API Response: #{response.parsed_response}"
    
      if response.success?
        stock_data = response.parsed_response["stock"].first  # Here we fetch the first stock object from the array
        {
          name: stock_data["name"],
          symbol: stock_data["symbol"],
          current_price: stock_data["price"]["amount"]
        }
      else
        nil
      end
    end
    

end
