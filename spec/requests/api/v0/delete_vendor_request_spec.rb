require 'rails_helper'

RSpec.describe 'Delete a Vendor by ID' do
  describe 'deletes an existing vendor' do
    scenario 'happy path' do
      test_data

      expect(@market1.vendor_count).to eq(2)
      expect(Vendor.count).to eq(3)
      expect(MarketVendor.count).to eq(3)

      delete "/api/v0/vendors/#{@vendor2.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq('')

      expect(@market1.vendor_count).to eq(1)
      expect(Vendor.count).to eq(2)
      expect(MarketVendor.count).to eq(2)
    end

    scenario 'sad path' do
      invalid_id = 465734683123123

      delete "/api/v0/vendors/#{invalid_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      could_not_find = JSON.parse(response.body, symbolize_names: true) 

      expect(could_not_find).to have_key(:errors)
      expect(could_not_find[:errors]).to be_an(Array)

      not_found_error = could_not_find[:errors][0]

      expect(not_found_error).to have_key(:detail)
      expect(not_found_error[:detail]).to eq("Couldn't find Vendor with 'id'=465734683123123")
    end
  end
end