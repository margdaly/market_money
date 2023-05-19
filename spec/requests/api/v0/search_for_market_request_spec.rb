require 'rails_helper'

RSpec.describe 'Search for a market' do
  before :each do
    market_search_data
  end

  describe 'returns markets searched for by state, city and/or name' do
    describe 'happy path' do
      scenario 'search by state' do
        VCR.use_cassette('market_search_by_state') do

        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?state=co', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        markets = JSON.parse(response.body, symbolize_names: true)

        expect(markets[:data].count).to eq(3)

        markets[:data].each do |market|
          expect(market).to have_key(:id)
          expect(market[:id]).to be_a(String)

          expect(market).to have_key(:type)
          expect(market[:type]).to eq('market')

          expect(market).to have_key(:attributes)

          attributes = market[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:street)
          expect(attributes[:street]).to be_a(String)

          expect(attributes).to have_key(:city)
          expect(attributes[:city]).to be_a(String)

          expect(attributes).to have_key(:county)
          expect(attributes[:county]).to be_a(String)

          expect(attributes).to have_key(:state)
          expect(attributes[:state]).to eq('CO')

          expect(attributes).to have_key(:zip)
          expect(attributes[:zip]).to be_a(String)

          expect(attributes).to have_key(:lat)
          expect(attributes[:lat]).to be_a(String)

          expect(attributes).to have_key(:lon)
          expect(attributes[:lon]).to be_a(String)
          end
        end
      end

      scenario 'search by name, city and state' do
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?city=aurora&state=co&name=farm', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        markets = JSON.parse(response.body, symbolize_names: true)

        expect(markets[:data].count).to eq(1)

        markets[:data].each do |market|
          expect(market).to have_key(:id)

          expect(market[:id]).to be_a(String)

          expect(market).to have_key(:type)
          expect(market[:type]).to eq('market')

          expect(market).to have_key(:attributes)

          attributes = market[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to eq("City Park Farmer's Market")

          expect(attributes).to have_key(:street)
          expect(attributes[:street]).to be_a(String)

          expect(attributes).to have_key(:city)
          expect(attributes[:city]).to eq('Aurora')

          expect(attributes).to have_key(:county)
          expect(attributes[:county]).to be_a(String)

          expect(attributes).to have_key(:state)
          expect(attributes[:state]).to eq('CO')

          expect(attributes).to have_key(:zip)
          expect(attributes[:zip]).to be_a(String)

          expect(attributes).to have_key(:lat)
          expect(attributes[:lat]).to be_a(String)

          expect(attributes).to have_key(:lon)
          expect(attributes[:lon]).to be_a(String)
        end
      end
    end

    describe 'sad path' do
      scenario 'invalid search params' do
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?city=melborne', headers: headers

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an(Array)
        error_info = error[:errors][0]

        expect(error_info).to have_key(:detail)
        expect(error_info[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end
    end
  end
end