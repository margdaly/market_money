require 'rails_helper'

RSpec.describe Market do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe '.vendor_count' do
      it 'returns the number of vendors at a market' do
        market1 = create(:market)
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)
        vendor3 = create(:vendor)
        create(:market_vendor, market_id: market1.id, vendor_id: vendor1.id)
        create(:market_vendor, market_id: market1.id, vendor_id: vendor2.id)

        expect(market1.vendor_count).to eq(2)

        create(:market_vendor, market_id: market1.id, vendor_id: vendor2.id)

        expect(market1.vendor_count).to eq(3)
      end
    end
  end
end