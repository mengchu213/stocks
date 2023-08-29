# spec/models/session_spec.rb
require 'rails_helper'

RSpec.describe Session, type: :model do
  # Factory
  it "has a valid factory" do
    user = create(:user)
    session = build(:session, user: user)
    expect(session).to be_valid
  end

  # Associations
  describe "associations" do
    it { should belong_to(:user) }
  end

  # Validations
  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end

  # Callbacks
  describe "before_create callbacks" do
    it "sets user_agent and ip_address from Current attributes" do
      allow(Current).to receive(:user_agent).and_return("TestAgent/1.0")
      allow(Current).to receive(:ip_address).and_return("192.168.0.1")

      session = create(:session)
      expect(session.user_agent).to eq("TestAgent/1.0")
      expect(session.ip_address).to eq("192.168.0.1")
    end
  end
end
