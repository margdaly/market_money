require 'rails_helper'

RSpec.describe 'Get One Vendor' do
  describe 'sends single vendor by its valid id' do
    scenario 'happy path' do
      test_data

      get "/api/v0/vendors/#{@vendor1.id}"

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(vendor[:data]).to be_a(Hash)

      vendor_data = vendor[:data]

      expect(vendor_data).to have_key(:id)
      expect(vendor_data[:id]).to be_an(String)

      expect(vendor_data).to have_key(:type)
      expect(vendor_data[:type]).to eq('vendor')

      expect(vendor_data).to have_key(:attributes)
      expect(vendor_data[:attributes]).to be_a(Hash)

      attributes = vendor_data[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:contact_name)
      expect(attributes[:contact_name]).to be_a(String)

      expect(attributes).to have_key(:contact_phone)
      expect(attributes[:contact_phone]).to be_a(String)

      expect(attributes).to have_key(:credit_accepted)
      expect(attributes[:credit_accepted]).to be_in([true, false])

      expect(attributes).to have_key(:states_sold_in)
      expect(attributes[:states_sold_in]).to be_an(Array)
    end

    scenario 'sad path' do
      invalid_id = 123123123123

      get "/api/v0/vendors/#{invalid_id}"

      failure = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      expect(failure).to have_key(:errors)

      errors = failure[:errors]

      expect(errors).to be_an(Array)
      expect(errors[0]).to have_key(:detail)
    end
  end
end