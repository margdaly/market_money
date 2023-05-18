require 'rails_helper'

RSpec.describe Market do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
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
end