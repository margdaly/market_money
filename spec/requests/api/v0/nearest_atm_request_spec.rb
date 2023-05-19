require 'rails_helper'

RSpec.describe 'ATM Search' do
  describe 'sends atms near a market location with closest first' do
    scenario 'happy path' do
      VCR.use_cassette('nearest_atms') do
        market1 = create(:market, :lat=>'35.077529', :lon=>'-106.600449')

        get "/api/v0/markets/#{market1.id}/nearest_atms"

        nearest_atms = JSON.parse(response.body, symbolize_names: true)
        require 'pry'; binding.pry

        expect(response).to be_successful
        expect(response.status).to eq(200)
      end
    end

    scenario 'sad path, no market id' do
      VCR.use_cassette('nearest_atms') do
        invalid_market = 123123333333

        get "/api/v0/markets/#{invalid_market}/nearest_atms"

        
      end
    end
  end
end