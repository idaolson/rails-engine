require 'rails_helper'

RSpec.describe 'merchants requests' do
  describe 'Get /api/v1/merchants' do
    it 'gets all merchants data for 20 merchants' do
      create_list(:merchant, 23)

      get '/api/v1/merchants'

      expect(response).to be_successful

      all_merchants_response = JSON.parse(response.body, symbolize_names: true)

      expect(all_merchants_response).to be_a Hash
      expect(all_merchants_response[:data]).to be_an Array
      expect(all_merchants_response[:data].count).to eq 20
      expect(all_merchants_response[:data][0]).to have_key :id
      expect(all_merchants_response[:data][0]).to have_key :type
      expect(all_merchants_response[:data][0][:type]).to eq('merchant')
      expect(all_merchants_response[:data][0]).to have_key :attributes
      expect(all_merchants_response[:data][0][:attributes]).to have_key :name
      expect(all_merchants_response[:data][0][:attributes][:name]).to be_a String
      expect(all_merchants_response[:data][0][:attributes]).to_not have_key :created_at
      expect(all_merchants_response[:data][0][:attributes]).to_not have_key :updated_at
    end

    it 'can take per page and page number params' do
      create_list(:merchant, 23)

      get '/api/v1/merchants', params: { per_page: 10, page: 2 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(10)
      expect(merchants.first[:id].to_i).to eq(Merchant.offset(10).first.id)
    end

    it 'fetches 1 page if page param is < 1 or non-integer' do
      create_list(:merchant, 23)

      get '/api/v1/merchants', params: { page: 0 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data].first).to have_key :id

      get '/api/v1/merchants', params: { page: -5 }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(20)

      get '/api/v1/merchants', params: { page: 'page 8' }

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(20)
    end

    it 'returns an empty array of data for 0 results' do
      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
      expect(merchants[:data]).to eq([])
    end
  end

  describe 'Get /api/v1/merchants/:id' do
    it 'gets all data for 1 merchant' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response).to be_a Hash
      expect(merchant_response[:data]).to be_a Hash
      expect(merchant_response[:data]).to have_key :id
      expect(merchant_response[:data]).to have_key :type
      expect(merchant_response[:data][:type]).to eq('merchant')
      expect(merchant_response[:data]).to have_key :attributes
      expect(merchant_response[:data][:attributes]).to have_key :name
      expect(merchant_response[:data][:attributes][:name]).to be_a String
      expect(merchant_response[:data][:attributes]).to_not have_key :created_at
      expect(merchant_response[:data][:attributes]).to_not have_key :updated_at
    end

    it "returns 404 if id doesn't exist" do
      get '/api/v1/merchants/1'

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end

  describe 'Get /api/v1/merchants/:id/items' do
    it "gets all of a merchant's items" do
      merchant = create(:merchant)
      create_list(:item, 10, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      merchant_items_response = JSON.parse(response.body, symbolize_names: true)
      expect(merchant_items_response).to be_a Hash
      expect(merchant_items_response[:data]).to be_an Array
      expect(merchant_items_response[:data][0]).to have_key :id
      expect(merchant_items_response[:data][0]).to have_key :type
      expect(merchant_items_response[:data][0][:type]).to eq('item')
      expect(merchant_items_response[:data][0]).to have_key :attributes
      expect(merchant_items_response[:data][0][:attributes]).to have_key :name
      expect(merchant_items_response[:data][0][:attributes][:name]).to be_a String
      expect(merchant_items_response[:data][0][:attributes]).to have_key :description
      expect(merchant_items_response[:data][0][:attributes][:description]).to be_a String
      expect(merchant_items_response[:data][0][:attributes]).to have_key :unit_price
      expect(merchant_items_response[:data][0][:attributes][:unit_price]).to be_a Float
      expect(merchant_items_response[:data][0][:attributes]).to_not have_key :created_at
      expect(merchant_items_response[:data][0][:attributes]).to_not have_key :updated_at
    end

    it 'returns a 404 if merchant not found' do
      get '/api/v1/merchants/90210/items'

      expect(response.status).to eq(404)
    end
  end

  describe 'Get /api/v1/merchants/find' do
    it 'finds a single merchant by name' do
      create(:merchant, name: 'Guillermo Buillermo')
      create(:merchant, name: 'Cassio Olson')

      query = 'ssio'
      get "/api/v1/merchants/find?name=#{query}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Cassio Olson')
    end

    it 'if multiple matches matches, returns in alphabetical order/case-sensitive' do
      create(:merchant, name: 'Guillermo')
      create(:merchant, name: 'Buillermo')
      create(:merchant, name: 'Cassio')

      query = 'iller'
      get "/api/v1/merchants/find?name=#{query}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Buillermo')
    end

    it 'returns empty response if no match on name' do
      create(:merchant, name: 'Cassio')

      query = 'ermo'
      get "/api/v1/merchants/find?name=#{query}"

      empty = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(empty[:data]).to be_a(Hash)
      expect(empty[:data][:id]).to eq(nil)
    end

    it 'returns 400 if no name or empty param' do
      get '/api/v1/merchants/find'

      expect(response.status).to eq(400)

      get '/api/v1/merchants/find?name='

      expect(response.status).to eq(400)
    end
  end
end
