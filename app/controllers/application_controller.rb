class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :authenticate, except: [:landing]

  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?  

  private
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
    
    def current_user
      @current_user ||= Current.session&.user
    end
    helper_method :current_user  # This makes current_user available to views
    
end
