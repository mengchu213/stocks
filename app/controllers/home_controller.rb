class HomeController < ApplicationController
  skip_before_action :authenticate, only: [:landing, :index]

  def index
    if current_user
      redirect_to portfolios_path
    else
      render :landing
    end
  end
  

  def profile
  end

  def landing
  end
end
