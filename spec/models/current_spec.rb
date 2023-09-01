require 'rails_helper'

RSpec.describe Current, type: :model do
  describe 'attributes' do
    let(:current) { build(:current) }

    it 'has session' do
      expect(current.session).not_to be_nil
    end

    it 'has user_agent' do
      expect(current.user_agent).to eq("Mozilla/5.0")
    end

    it 'has ip_address' do
      expect(current.ip_address).to eq("127.0.0.1")
    end
  end

  describe 'delegation' do
    context 'with session containing user' do
      let(:user) { create(:user) }
      let(:current) { Current.instance }

      before do
        current.session = OpenStruct.new(user: user)
      end

      it 'delegates user to session' do
        expect(current.user).to eq(user)
      end
    end

    context 'with session not containing user' do
      let(:current) { Current.instance }

      before do
        current.session = OpenStruct.new
      end

      it 'returns nil for user' do
        expect(current.user).to be_nil
      end
    end
  end
end
