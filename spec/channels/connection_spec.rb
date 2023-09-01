require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  def connect_with_headers(headers = {})
    connect "/cable", headers: headers
  end

  it 'successfully connects' do
    connect_with_headers
    expect(connection).to be_a(ApplicationCable::Connection)
  end

end
