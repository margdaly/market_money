require 'rails_helper'

describe 'Vendors API' do
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

  describe 'creates a new vendor' do
    scenario 'happy path' do
      vendor_params = ({
                        "name": 'Buzzy Bees',
                        "description": "local honey and wax products",
                        "contact_name": "Berlyn Couwer",
                        "contact_phone": "8389928383",
                        "credit_accepted": false
                        })
      headers = {'CONTENT_TYPE' => 'application/json'}

      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)
    end

    scenario 'sad path' do
      vendor_params = ({
                        "name": "Buzzy Bees",
                        "description": "local honey and wax products",
                        "credit_accepted": false
                      })
      headers = {'CONTENT_TYPE' => 'application/json'}

      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      invalid = JSON.parse(response.body, symbolize_names: true)

      expect(invalid).to have_key(:errors)
      expect(invalid[:errors]).to be_an(Array)

      invalid_error = invalid[:errors][0]

      expect(invalid_error).to have_key(:detail)
      expect(invalid_error[:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end

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

  describe 'deletes an existing vendor' do
    scenario 'happy path' do
      test_data

      expect(@market1.vendor_count).to eq(2)
      expect(Vendor.count).to eq(3)
      expect(MarketVendor.count).to eq(2)

      delete "/api/v0/vendors/#{@vendor2.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq('')

      expect(@market1.vendor_count).to eq(1)
      expect(Vendor.count).to eq(2)
      expect(MarketVendor.count).to eq(1)
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