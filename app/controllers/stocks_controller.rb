class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]


  def index
    @stocks = FetchStocksService.new(query: params[:query], page: params[:page]).call
    @user_portfolios = Current.user.portfolios.includes(:stock).group_by { |p| p.stock.symbol }

    unless @stocks
      flash[:alert] = "There was an error fetching stocks. Please try again later."
    end
  end


  def show
  end

  
  


  def new
    @stock = Stock.new
  end

  def edit
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      flash[:notice] = "Stock successfully created."
      redirect_to stocks_path
    else
      render :new
    end
  end

  def update
    if @stock.update(stock_params)
      redirect_to @stock, notice: "Stock was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_url, notice: "Stock was successfully destroyed.", status: :see_other
  end


  private

  def fetch_all_stocks
    PhisixService.all_stocks['stock']
  rescue => e
    flash[:alert] = "There was an error fetching stocks. Please try again later."
    nil
  end

  def filter_and_paginate_stocks(all_stocks)
    if params[:query].present?
      cleaned_query = params[:query].strip.downcase
      filtered_stocks = all_stocks.select do |stock|
        stock['name'].downcase.include?(cleaned_query) || stock['symbol'].downcase.include?(cleaned_query)
      end
      Kaminari.paginate_array(filtered_stocks).page(params[:page]).per(10)
    else
      Kaminari.paginate_array(all_stocks).page(params[:page]).per(10)
    end
  end

  def set_stock
    @stock = PhisixService.stock_by_symbol(params[:symbol])
  rescue => e
    flash[:alert] = "There was an error fetching the stock details. Please try again later."
    redirect_to stocks_path
  end

  def stock_params
    params.require(:stock).permit(:name, :symbol, :current_price)
  end
end
