# # spec/requests/users_request_spec.rb

# require 'rails_helper'

# RSpec.describe "Users", type: :request do
#   let(:admin) { create(:user, role: 'Admin', status: 'Approved') }
#   let(:trader) { create(:user, role: 'Trader', status: 'Pending') }
  
#   def sign_in(user)
#     post sessions_create_path, params: { email: user.email, password: 'password123' }
#   end
  
  

#   describe "GET #index" do
#     context "when user is an admin" do
#       before { sign_in(admin) }

#       it "lists all users" do
#         get users_path
#         expect(response).to have_http_status(200)
#       end
#     end

#     context "when user is not an admin" do
#       before { sign_in(trader) }

#       it "redirects to root path" do
#         get users_path
#         expect(response).to redirect_to(root_path)
#       end
#     end
#   end

#   describe "GET #new" do
#     context "when user is an admin" do
#       before { sign_in(admin) }

#       it "renders the new user form" do
#         get new_user_path
#         expect(response).to have_http_status(200)
#       end
#     end

#     context "when user is not an admin" do
#       before { sign_in(trader) }

#       it "redirects to root path" do
#         get new_user_path
#         expect(response).to redirect_to(root_path)
#       end
#     end
#   end

#   describe "POST #create" do
#     context "when user is an admin" do
#       before { sign_in(admin) }

#       it "creates a new user" do
#         expect {
#           post users_path, params: { user: attributes_for(:user) }
#         }.to change(User, :count).by(1)
#       end
#     end

#     context "when user is not an admin" do
#       before { sign_in(trader) }

#       it "does not create a new user" do
#         expect {
#           post users_path, params: { user: attributes_for(:user) }
#         }.not_to change(User, :count)
#       end
#     end
#   end

#   # You can add similar contexts for `edit`, `update`, `destroy`, `approvals`, and `approve`.

#   # For brevity, I'm omitting them here, but it's mostly a repetition with variations 
#   # depending on the action and the type of user (admin or trader).
# end
