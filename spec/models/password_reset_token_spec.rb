require 'rails_helper'

RSpec.describe PasswordResetToken, type: :model do
  it "has a valid factory" do
    user = create(:user)
    password_reset_token = build(:password_reset_token, user: user)
    expect(password_reset_token).to be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end
end
