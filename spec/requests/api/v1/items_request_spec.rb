require 'rails_helper'

RSpec.describe "items requests" do
  describe "Get /api/v1/items" do
    it "gets all item data for 20 items" do
      merchant = create(:merchant)
      create_list(:item, 23, merchant: merchant)

      get '/api/v1/items'

      expect(response).to be_successful

      all_items_response = JSON.parse(response.body, symbolize_names: true)

      expect(all_items_response).to be_a Hash
      expect(all_items_response[:data]).to be_an Array
      expect(all_items_response[:data].count).to eq 20
      expect(all_items_response[:data][0]).to have_key :id
      expect(all_items_response[:data][0]).to have_key :type
      expect(all_items_response[:data][0][:type]).to eq("item")
      expect(all_items_response[:data][0]).to have_key :attributes
      expect(all_items_response[:data][0][:attributes]).to have_key :name
      expect(all_items_response[:data][0][:attributes][:name]).to be_a String
      expect(all_items_response[:data][0][:attributes]).to have_key :description
      expect(all_items_response[:data][0][:attributes][:description]).to be_a String
      expect(all_items_response[:data][0][:attributes]).to have_key :unit_price
      expect(all_items_response[:data][0][:attributes][:unit_price]).to be_a Float
      expect(all_items_response[:data][0][:attributes]).to_not have_key :created_at
      expect(all_items_response[:data][0][:attributes]).to_not have_key :updated_at
    end

    it 'gets 20 items and page 1 by default' do
      merchant = create(:merchant)
      create_list(:item, 23, merchant: merchant)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)
      expect(items[:data].first[:id].to_i).to eq(Item.first.id)
    end

    it 'can take per page and page number params' do
      merchant = create(:merchant)
      create_list(:item, 23, merchant: merchant)

      get '/api/v1/items', params: { per_page: 10, page: 2 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(10)
      expect(items[:data].first[:id].to_i).to eq(Item.offset(10).first.id)
    end

    it 'gets page one if page number params are less that one or not an integer' do
      merchant = create(:merchant)
      create_list(:item, 23, merchant: merchant)

      get '/api/v1/items', params: { page: 0 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)
      expect(items[:data].first).to have_key :id

      get '/api/v1/items', params: { page: -5 }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)

      get '/api/v1/items', params: { page: 'page 8' }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(20)
    end
  end

  describe "Get /api/v1/items/:id" do
    it "gets all data for 1 item" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      item_response = JSON.parse(response.body, symbolize_names: true)

      expect(item_response).to be_a Hash
      expect(item_response[:data]).to be_a Hash
      expect(item_response[:data]).to have_key :id
      expect(item_response[:data]).to have_key :type
      expect(item_response[:data][:type]).to eq("item")
      expect(item_response[:data]).to have_key :attributes
      expect(item_response[:data][:attributes]).to have_key :name
      expect(item_response[:data][:attributes][:name]).to be_a String
      expect(item_response[:data][:attributes]).to have_key :description
      expect(item_response[:data][:attributes][:description]).to be_a String
      expect(item_response[:data][:attributes]).to have_key :unit_price
      expect(item_response[:data][:attributes][:unit_price]).to be_a Float
      expect(item_response[:data][:attributes]).to_not have_key :created_at
      expect(item_response[:data][:attributes]).to_not have_key :updated_at
    end
  end

  describe "Post /api/v1/items" do
    it "creates new item and renders json record" do
      merchant = create(:merchant)
      item_params = {
                "name": "Ida",
                "description": "A human female chicken",
                "unit_price": 100.99,
                "merchant_id": merchant.id.to_i
              }
      headers = {"CONTENT_TYPE" => "application/json"}
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      new_item = Item.last
      output = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(output[:attributes][:name]).to eq(item_params[:name])
      expect(new_item.name).to eq(item_params[:name])
      expect(output[:attributes][:description]).to eq(item_params[:description])
      expect(new_item.description).to eq(item_params[:description])
      expect(output[:attributes][:unit_price]).to eq(item_params[:unit_price])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
    end
  end

  describe 'Delete /api/v1/items/:id' do
    it 'destroys an item when it exists' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
