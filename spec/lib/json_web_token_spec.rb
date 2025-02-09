require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:payload) { { user_id: 1 } }
  let(:token) { JsonWebToken.encode(payload) }

  describe '.encode' do
    it 'returns a JWT token' do
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a JWT token' do
      decoded = JsonWebToken.decode(token)
      expect(decoded[:user_id]).to eq(payload[:user_id])
    end
  end
end
