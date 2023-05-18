require 'rails_helper'

RSpec.describe MarketVendor do
  describe 'relationships' do
    it { should belong_to(:market) }
    it { should belong_to(:vendor) }
  end

  describe 'validations' do
    it 'validates association uniqueness' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = create(:market_vendor, market: market, vendor: vendor)

      expect(market_vendor).to be_valid
      expect { create(:market_vendor, market: market, vendor: vendor) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end