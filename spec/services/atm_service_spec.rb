require 'rails_helper'

RSpec.describe 'ATM Service' do 
  describe 'nearest_atms(lat, lon)' do
    it 'returns a list or nearby atms' do
      VCR.use_cassette('nearest_atms') do

        nearest_atms = AtmService.new.nearest_atms('35.077529', '-106.600449')

        expect(nearest_atms).to be_a(Hash)
        expect(nearest_atms[:results]).to be_an(Array)

        atm_data = nearest_atms[:results][0]

        expect(atm_data).to have_key(:poi)
        expect(atm_data[:poi][:name]).to be_a(String)

        expect(atm_data).to have_key(:address)
        expect(atm_data[:address][:freeformAddress]).to be_a(String)

        expect(atm_data).to have_key(:position)
        expect(atm_data[:position][:lat]).to be_a(Float)
        expect(atm_data[:position][:lon]).to be_a(Float)

        expect(atm_data).to have_key(:dist)
        expect(atm_data[:dist]).to be_a(Float)
      end
    end
  end
end