require 'rails_helper'

RSpec.describe Market do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe '.vendor_count' do
      it 'returns the number of vendors at a market' do
        market1 = Market.create!(name: 'Cherry Creek Farmers Market',
                                 street: '123 Colfax Ave',
                                 city: 'Denver',
                                 county: 'Denver',
                                 state: 'CO',
                                 zip: '80206',
                                 lat: '39.740986',
                                 lon: '-104.949972')

        vendor1 = Vendor.create!(name: 'Vendor 1',
                                 description: 'This is vendor 1',
                                 contact_name: 'Vendor 1 Contact',
                                 contact_phone: '123.456.7890',
                                 credit_accepted: true)
        vendor2 = Vendor.create!(name: 'Vendor 2',
                                 description: 'This is vendor 2',
                                 contact_name: 'Vendor 2 Contact',
                                 contact_phone: '123.456.7000',
                                 credit_accepted: true)

        MarketVendor.create!(market_id: market1.id, vendor_id: vendor1.id)

        expect(market1.vendor_count).to eq(1)

        MarketVendor.create!(market_id: market1.id, vendor_id: vendor2.id)

        expect(market1.vendor_count).to eq(2)
      end
    end
  end
end