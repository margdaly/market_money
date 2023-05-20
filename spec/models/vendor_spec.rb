require 'rails_helper'

RSpec.describe Vendor do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    it { should validate_inclusion_of(:credit_accepted).in_array([true, false]) }
  end

  describe 'class methods' do
    describe '.states_sold_in' do
      it 'returns a list of states the vendor sells in' do
        test_data
        vendor = create(:vendor)

        expect(vendor.states_sold_in).to eq([])
        expect(@vendor1.states_sold_in).to eq(['Test State'])
        expect(@vendor2.states_sold_in).to eq(['Test State', 'Hawaii'])
      end
    end
  end
end