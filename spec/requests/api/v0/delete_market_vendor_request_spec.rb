require 'rails_helper'

RSpec.describe 'Delete a Market Vendor' do
  describe 'deletes an existing market vendor' do
    scenario 'happy path' do
      market1 = create(:market)
      market2 = create(:market)
      vendor1 = create(:vendor)
      create(:market_vendor, market: market1, vendor: vendor1)
      create(:market_vendor, market: market2, vendor: vendor1)

      expect(market1.vendor_count).to eq(1)
      expect(market2.vendor_count).to eq(1)
      expect(MarketVendor.count).to eq(2)

      market_vendor_params = { 'market_id': market1.id, 'vendor_id': vendor1.id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq('')

      expect(market1.vendor_count).to eq(0)
      expect(market2.vendor_count).to eq(1)
      expect(MarketVendor.count).to eq(1)

      get "/api/v0/markets/#{market1.id}/vendors"

      market1 = JSON.parse(response.body, symbolize_names: true)

      expect(market1).to have_key(:data)

      vendors_data = market1[:data]

      expect(vendors_data).to be_an(Array)
      expect(vendors_data.count).to eq(0)
    end

    scenario 'sad path' do
      market = create(:market)
      invalid_vendor_id = 4223

      market_vendor_params = { 'market_id': market.id, 'vendor_id': invalid_vendor_id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:errors)

      errors = data[:errors]

      expect(errors).to be_an(Array)
      expect(errors.first[:detail]).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{invalid_vendor_id} exists")
    end
  end
end