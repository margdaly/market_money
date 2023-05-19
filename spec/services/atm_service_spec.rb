require 'rails_helper'

RSpec.describe 'ATM Service' do
  describe 'nearby_atms(lat, lon)' do
    it 'returns a list or nearby atms' do
      VCR.use_cassette('nearest_atms') do
        market = create(:market, lat: '35.077529', lon: '-106.600449')
        nearby_atms = AtmService.nearby_atms(market.lat, market.lon)

        expect(nearby_atms).to be_a(Hash)
        expect(nearby_atms[:results]).to be_an(Array)

        atm_data = nearby_atms[:results][0]

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