require 'rails_helper'

RSpec.describe 'ATM' do
  describe 'initialize' do
    it 'exists and has attributes' do
      attributes = {
        name: 'ATM',
        address: '123 Main St',
        lat: '39.750783',
        lon: '-104.996439',
        distance: '0.10521432030421865'
      }

      atm = Atm.new(attributes)

      expect(atm).to be_a(Atm)
      expect(atm.name).to eq('ATM')
      expect(atm.address).to eq('123 Main St')
      expect(atm.lat).to eq('39.750783')
      expect(atm.lon).to eq('-104.996439')
      expect(atm.distance).to eq('0.10521432030421865')
    end
  end
end