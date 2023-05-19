require 'rails_helper'

RSpec.describe 'AtmFacade' do
  describe 'class methods' do
    describe 'nearby_atms' do
      it 'returns nearby atms data' do
        VCR.use_cassette("nearby_atms") do
          atm_data = AtmFacade.new.find_nearby_atms(35.079044, -106.60068)

          expect(atm_data).to be_an(Array)
          expect(atm_data.count).to eq(10)

          first_atm = atm_data.first
          expect(first_atm).to be_an(Atm)
          expect(first_atm.name).to eq('ATM')
          expect(first_atm.address).to eq('3902 Central Avenue Southeast, Albuquerque, NM 87108')
          expect(first_atm.lat).to eq(35.079044)
          expect(first_atm.lon).to eq(-106.60068)
          expect(first_atm.distance).to eq(0.10548811068360774)
        end
      end
    end
  end
end