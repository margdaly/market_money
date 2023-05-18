require 'rails_helper'

RSpec.describe 'Update a Vendor' do
  describe 'updates an existing vendor' do
    scenario 'happy path' do
      test_data
      expect(@vendor1.contact_name).to eq("Contact 1")
      expect(@vendor1.credit_accepted).to eq(true)

      vendor_params = ({
                        "contact_name": "Kimberly Couwer",
                        "credit_accepted": false
                      }) 
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v0/vendors/#{@vendor1.id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(updated_vendor).to have_key(:data)
      expect(updated_vendor[:data]).to be_a(Hash)

      updated_data = updated_vendor[:data]

      expect(updated_data).to have_key(:id)
      expect(updated_data[:id]).to be_a(String)

      expect(updated_data).to have_key(:type)
      expect(updated_data[:type]).to eq('vendor')

      expect(updated_data).to have_key(:attributes)
      expect(updated_data[:attributes]).to be_a(Hash)

      updated_attr = updated_data[:attributes]

      expect(updated_attr).to have_key(:name)
      expect(updated_attr).to have_key(:description)
      expect(updated_attr).to have_key(:contact_phone)

      expect(updated_attr).to have_key(:contact_name)
      expect(updated_attr[:contact_name]).to eq("Kimberly Couwer")

      expect(updated_attr).to have_key(:credit_accepted)
      expect(updated_attr[:credit_accepted]).to eq(false)
    end

    scenario 'sad path for invalid vendor id' do
      invalid_id = 123123123123
      vendor_params = ({
                        "contact_name": "Kimberly Couwer",
                        "credit_accepted": false
                      }) 
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch "/api/v0/vendors/#{invalid_id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      invalid = JSON.parse(response.body, symbolize_names: true)

      expect(invalid).to have_key(:errors)
      expect(invalid[:errors]).to be_an(Array)

      error_info = invalid[:errors][0]

      expect(error_info).to have_key(:detail)
      expect(error_info[:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end

    scenario 'sad path for blank field' do
      test_data 

      vendor_params = ({
                        "name": "",
                        "contact_name": "",
                        "credit_accepted": false
                      }) 
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{@vendor2.id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      blank_field = JSON.parse(response.body, symbolize_names: true)

      expect(blank_field).to have_key(:errors)
      expect(blank_field[:errors]).to be_an(Array)

      error_info = blank_field[:errors][0]

      expect(error_info).to have_key(:detail)
      expect(error_info[:detail]).to eq("Validation failed: Name can't be blank, Contact name can't be blank")
    end
  end
end