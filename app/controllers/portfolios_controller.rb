class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: %i[ show edit update destroy ]

  def index
    @portfolios = current_user_portfolios.page(params[:page]).per(7)
    @all_portfolios = current_user_portfolios
  end
  

  private

    def set_portfolio
      @portfolio = Portfolio.includes(:stock).find(params[:id]) 
    end

    def portfolio_params
      params.require(:portfolio).permit(:quantity, :stock_id) 
    end

    def current_user_portfolios
      Current.user.portfolios.includes(:stock)
    end
end
