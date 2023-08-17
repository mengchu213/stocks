class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]

  # GET /stocks
  def index
    all_stocks = PhisixService.all_stocks['stock']
  
    if params[:query].present?
      cleaned_query = params[:query].strip.downcase
      @stocks = all_stocks.select do |stock|
        stock['name'].downcase.include?(cleaned_query) || stock['symbol'].downcase.include?(cleaned_query)
      end
    else
      @stocks = all_stocks.first(20)  # Display the first 10 stocks by default
    end
  end
  
  

  # GET /stocks/1
  def show
    @stock = PhisixService.stock_by_symbol(params[:symbol])
  end
  
  

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      flash[:notice] = "Stock successfully created."
      redirect_to stocks_path
    else
      render :new
    end
  end

  # PATCH/PUT /stocks/1
  def update
    if @stock.update(stock_params)
      redirect_to @stock, notice: "Stock was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /stocks/1
  def destroy
    @stock.destroy
    redirect_to stocks_url, notice: "Stock was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = PhisixService.stock_by_symbol(params[:symbol])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:name, :symbol, :current_price)
    end
end
