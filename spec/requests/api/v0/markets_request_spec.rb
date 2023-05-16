require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of all the markets' do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      market = market[:attributes]

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_a(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_a(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_a(String)

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_an(Integer)
    end
  end

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