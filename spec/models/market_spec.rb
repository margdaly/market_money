require 'rails_helper'

RSpec.describe Market do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe '.vendor_count' do
      it 'returns the number of vendors at a market' do
        test_data

        expect(@market1.vendor_count).to eq(2)

        create(:market_vendor, market_id: @market1.id, vendor_id: @vendor3.id)

        expect(@market1.vendor_count).to eq(3)
      end
    end
  end

  describe 'filter_by' do
    before :each do
      market_search_data
    end

    describe 'filter_by_state' do
      it 'returns all markets that have a u.s. state that matches filter' do
        co_markets = Market.filter_by_state('CO')
        expect(co_markets).to eq([@market1, @market2, @market3])
      end
    end

    describe 'filter_by_city' do
      it 'returns all markets that have a city that matches filter' do
        den_markets = Market.filter_by_city('Denver')
        on_markets = Market.filter_by_city('on')

        expect(den_markets).to eq([@market2, @market3])
        expect(on_markets).to eq([@market5, @market6])
      end
    end

    describe 'filter_by_name' do
      it 'returns all markets that have a name that matches filter' do
        farm_markets = Market.filter_by_name('farm')

        expect(farm_markets).to eq([@market1, @market2, @market3, @market4, @market5, @market6])
      end
    end

    describe 'filter_all' do
      it 'returns all markets that have a name matches filter' do
        params = { 'name': 'farmer' } 
        expect(Market.filter_all(params)).to eq([@market1, @market2, @market3, @market4, @market5, @market6])
      end

      it 'returns all markets that have a city that matches filter' do
        params = { 'city': 'denv' }
        expect(Market.filter_all(params)).to eq([@market2, @market3])
      end

      it 'returns all markets that have a u.s. state that matches filter' do
        params = { 'state': 'co' }
        expect(Market.filter_all(params)).to eq([@market1, @market2, @market3])
      end

      it 'returns all markets that match two filters' do
        params = { 'name': 'farmer', 'state': 'az' }
        expect(Market.filter_all(params)).to eq([@market6])
      end

      it 'returns all markets that match three filters' do
        params = { 'name': 'farmer', 'state': 'co', 'city': 'aurora' }
        expect(Market.filter_all(params)).to eq([@market1])
      end
    end
  end
end