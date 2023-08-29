# spec/requests/home_controller_spec.rb

require 'rails_helper'

RSpec.describe "HomeController", type: :request do
  let(:user) { create(:user) } # Assuming you have a factory for User

  # Stubbing Auth0 authentication
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'when user is signed in' do
      before { get root_path }

      it 'redirects to portfolios path' do
        expect(response).to redirect_to(portfolios_path)
      end
    end

    context 'when user is not signed in' do
      # Override the before block to simulate no user
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        get root_path
      end

      it 'renders the landing page' do
        expect(response).to render_template(:landing)
      end
    end
  end

  describe "GET #profile" do
    context "when user is signed in" do
      let(:user) { create(:user) } # assuming you have a user factory
      let(:user_session) { create(:session, user: user) }

      before do
        cookies[:session_token] = user_session.id
      end
      

     
    end
  
  
  
  

    context 'when user is not signed in' do
   
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
        get profile_path
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(sign_in_path) # This might be different, adjust as per your Auth0 setup
      end
    end
  end

  describe 'GET #landing' do
    before { get landing_path }

    it 'renders the landing page' do
      expect(response).to render_template(:landing)
    end
  end
end
