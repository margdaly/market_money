require 'rails_helper'

RSpec.describe 'Create a Vendor' do
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
end