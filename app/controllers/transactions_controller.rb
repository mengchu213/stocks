class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions
  def index
    if Current.user.role == 'Admin'
      @transactions = Transaction.all.order(created_at: :desc).page(params[:page]).per(10)
      @user = nil 
    else
      @user = User.find(params[:user_id])
      @transactions = @user.transactions.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show; end

  def new
    @stock_symbol = params[:stock_symbol]
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
  end

  def edit; end

  def create
    stock = StockFetcherOrCreateService.new(params[:stock_symbol]).call

    unless stock
      flash[:alert] = "Stock with symbol #{params[:stock_symbol]} could not be fetched or created."
      redirect_to new_transaction_path and return
    end

    @transaction = TransactionCreatorService.new(Current.user, stock, transaction_params).call

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
      render :new
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :quantity)
  end
end
