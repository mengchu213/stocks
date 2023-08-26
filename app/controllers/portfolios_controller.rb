class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: %i[ show edit update destroy ]

  def index
    @portfolios = current_user_portfolios.page(params[:page]).per(7)
    @all_portfolios = current_user_portfolios
  end
  

  # GET /portfolios/1
  def show
  end

  # GET /portfolios/new
  def new
    @portfolio = Portfolio.new
  end

  # GET /portfolios/1/edit
  def edit
  end

  # POST /portfolios
  def create
    @portfolio = current_user_portfolios.build(portfolio_params)

    if @portfolio.save
      redirect_to @portfolio, notice: "Portfolio was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /portfolios/1
  def update
    if @portfolio.update(portfolio_params)
      redirect_to @portfolio, notice: "Portfolio was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /portfolios/1
  def destroy
    @portfolio.destroy
    redirect_to portfolios_url, notice: "Portfolio was successfully destroyed.", status: :see_other
  end

  private

    def set_portfolio
      @portfolio = Portfolio.includes(:stock).find(params[:id]) # added includes(:stock) for eager loading if needed
    end

    def portfolio_params
      params.require(:portfolio).permit(:quantity, :stock_id) # removed :user_id from permitted params
    end

    def current_user_portfolios
      Current.user.portfolios.includes(:stock)
    end
end
