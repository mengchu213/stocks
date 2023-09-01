require 'rails_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do
  before do
    stub_connection
    subscribe
  end

  it 'successfully subscribes' do
    expect(subscription).to be_confirmed
  end
end
