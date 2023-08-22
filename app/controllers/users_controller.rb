class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:index, :new, :create, :destroy]

  before_action :authorize_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  def approvals
    @pending_traders = User.where(status: 'Pending')
  end

  def approve
    user = User.find(params[:id])
    if user.update(status: 'Approved')
      # Send approval email
      UserMailer.with(user: user).approval_notification.deliver_now
  
      redirect_to approvals_users_path, notice: "Trader approved and notified successfully!"
    else
      redirect_to approvals_users_path, alert: "There was an error approving the trader."
    end
  end
  
  
  

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role, :status, :verified, :balance, :password, :password_confirmation)
  end

  def check_admin
    redirect_to root_path, alert: 'Not authorized!' unless Current.user.role == 'Admin'
  end

  def authorize_user
    unless Current.user.role == 'Admin'
      redirect_to root_path, alert: 'You do not have permission to edit this account.'
    end
  end
end
