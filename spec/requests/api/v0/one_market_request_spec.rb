require 'rails_helper'

RSpec.describe 'Get One Market' do
  describe 'sends a single market by its valid id' do
    scenario 'happy path' do
      test_data

      get "/api/v0/markets/#{@market1.id}"

      market = JSON.parse(response.body, symbolize_names: true)
      market_data = market[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(market_data).to have_key(:id)
      expect(market_data[:id]).to be_a(String)

      expect(market_data).to have_key(:type)
      expect(market_data[:type]).to eq('market')

      expect(market_data).to have_key(:attributes)
      expect(market_data[:attributes]).to be_a(Hash)

      attributes = market[:data][:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:street)
      expect(attributes[:street]).to be_a(String)

      expect(attributes).to have_key(:city)
      expect(attributes[:city]).to be_a(String)

      expect(attributes).to have_key(:county)
      expect(attributes[:county]).to be_a(String)

      expect(attributes).to have_key(:state)
      expect(attributes[:state]).to be_a(String)

      expect(attributes).to have_key(:zip)
      expect(attributes[:zip]).to be_a(String)

      expect(attributes).to have_key(:lat)
      expect(attributes[:lat]).to be_a(String)

      expect(attributes).to have_key(:lon)
      expect(attributes[:lon]).to be_a(String)

      expect(attributes).to have_key(:vendor_count)
      expect(attributes[:vendor_count]).to be_an(Integer)
    end

    scenario 'sad path' do
      invalid_id = 123123123123

      get "/api/v0/markets/#{invalid_id}"

      failure = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      expect(failure).to have_key(:errors)

      errors = failure[:errors]

      expect(errors).to be_an(Array)
      expect(errors[0]).to have_key(:detail)
      expect(errors[0][:detail]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
    end
  end
end