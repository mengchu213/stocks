class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: %i[ show edit update destroy ]

  # GET /portfolios
  def index
    @portfolios = Current.user.portfolios
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
    @portfolio = Portfolio.new(portfolio_params)

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
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def portfolio_params
      params.require(:portfolio).permit(:quantity, :user_id, :stock_id)
    end
end
