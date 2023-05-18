require 'rails_helper'

RSpec.describe 'Create a Market Vendor' do
  before { test_data }

  describe 'creates a new market vendor' do
    scenario 'happy path' do
      expect(@market1.vendor_count).to eq(2)

      market_vendor_params = {
                              'market_id': @market1.id,
                              'vendor_id': @vendor3.id
                            }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(@market1.vendor_count).to eq(3)

      new_mv = JSON.parse(response.body, symbolize_names: true)

      expect(new_mv).to have_key(:message)
      expect(new_mv[:message]).to eq('Successfully added vendor to market')
    end

    describe 'sad path, custom error messages' do
      scenario 'invalid market id' do
        invalid_market_id = 987654321
        market_vendor_params = {
                                  'market_id': invalid_market_id,
                                  'vendor_id': @vendor2.id
                              }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an(Array)

        error_message = error[:errors][0]

        expect(error_message).to have_key(:detail)
        expect(error_message[:detail]).to eq('Validation failed: Market must exist')
      end

      scenario 'invalid vendor id' do
        invalid_vendor_id = 987654321
        market_vendor_params = {
                                  'market_id': @market1.id,
                                  'vendor_id': invalid_vendor_id
                                }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an(Array)

        error_message = error[:errors][0]

        expect(error_message).to have_key(:detail)
        expect(error_message[:detail]).to eq('Validation failed: Vendor must exist')
      end

      scenario 'missing both vendor and market ids' do
        invalid_vendor_id = 987654321
        invalid_market_id = 432198765
        market_vendor_params = {
                                  'market_id': invalid_market_id,
                                  'vendor_id': invalid_vendor_id
                                }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an(Array)

        error_message = error[:errors][0]

        expect(error_message).to have_key(:detail)
        expect(error_message[:detail]).to eq('Validation failed: Market must exist, Vendor must exist')
      end

      scenario 'market and vendor association already exists' do
        vendor_id = @mv1.vendor_id
        market_id = @mv1.market_id
        market_vendor_params = {
                                  'market_id': market_id,
                                  'vendor_id': vendor_id
                                }

        headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an(Array)

        error_message = error[:errors][0]

        expect(error_message).to have_key(:detail)
        expect(error_message[:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
      end
    end
  end
end