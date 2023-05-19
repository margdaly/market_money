require 'rails_helper'

RSpec.describe 'ATM' do
  describe 'initialize' do
    it 'exists and has attributes' do
      data = {
        poi: { name: 'ATM' },
        address: { freeformAddress: '3902 Central Avenue Southeast, Albuquerque, NM 87108' },
        position: { "lat": 35.07904, "lon": -106.60068 },
        dist: 169.766658
      }
      atm = Atm.new(data)

      expect(atm).to be_a(Atm)
      expect(atm.name).to eq('ATM')
      expect(atm.address).to eq('3902 Central Avenue Southeast, Albuquerque, NM 87108')
      expect(atm.lat).to eq(35.07904)
      expect(atm.lon).to eq(-106.60068)
      expect(atm.distance).to eq(0.10548811068360774)
    end
  end
end