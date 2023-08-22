class HomeController < ApplicationController
  skip_before_action :authenticate, only: [:landing]
  before_action :redirect_if_logged_in, only: [:landing]
  def index
  end
  def profile
  end
  def landing
     
  end

  private

  def redirect_if_logged_in
    redirect_to portfolios_path if user_signed_in? 
  end
end
