# require 'rails_helper'

# RSpec.describe Identity::EmailsController, type: :controller do
#   let(:user) { create(:user) } # Assuming you have a user factory

#   before do
#     # Simulate a logged in user
#      sign_in(user)
#     allow(controller).to receive(:current_user).and_return(user)
#   end

#   describe "GET #edit" do
#     it "renders the edit template" do
#       get :edit
#       expect(response).to render_template(:edit)
#     end
#   end

#   describe "PUT #update" do
#     let(:valid_email) { "new_email@example.com" }
#     let(:invalid_email) { "" } # or whatever is invalid for your model
    
#     context "with invalid password" do
#       it "redirects with an alert" do
#         put :update, params: { current_password: "wrongpassword", email: valid_email }
#         expect(response).to redirect_to(edit_identity_email_path)
#         expect(flash[:alert]).to eq("The password you entered is incorrect")
#       end
#     end

#     context "with valid password" do
#       before do
#         allow(user).to receive(:authenticate).and_return(true)
#       end

#       context "with valid email" do
#         it "updates the user email and redirects" do
#           expect {
#             put :update, params: { current_password: "correctpassword", email: valid_email }
#             user.reload
#           }.to change(user, :email).to(valid_email)
#           expect(response).to redirect_to(root_path)
#         end
#       end

#       context "with invalid email" do
#         it "renders edit with status :unprocessable_entity" do
#           put :update, params: { current_password: "correctpassword", email: invalid_email }
#           expect(response).to render_template(:edit)
#           expect(response.status).to eq(422)
#         end
#       end
#     end
#   end
# end
