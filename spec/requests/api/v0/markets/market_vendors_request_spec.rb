require 'rails_helper'

RSpec.describe 'Market Vendors API' do
  describe 'sends a list of all vendors associated with a valid market' do
    scenario 'happy path' do
      test_data

      get "/api/v0/markets/#{@market1.id}/vendors"

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(vendors).to have_key(:data)
      expect(vendors[:data]).to be_an(Array)
      
      vendors[:data].each do |vendor|

        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)

        attributes = vendor[:attributes]

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
      end
    end

    scenario 'sad path' do
      invalid_id = 123123123123

      get "/api/v0/markets/#{invalid_id}/vendors"

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