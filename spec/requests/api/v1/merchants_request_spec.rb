require 'rails_helper'

RSpec.describe "merchants requests" do
  describe "Get /api/v1/merchants" do
    it "gets all merchants data for 20 merchants" do
      create_list(:merchant, 23)

      get '/api/v1/merchants'

      expect(response).to be_successful

      all_merchants_response = JSON.parse(response.body, symbolize_names: true)

      expect(all_merchants_response).to be_a Hash
      expect(all_merchants_response[:data]).to be_an Array
      expect(all_merchants_response[:data].count).to eq 20
      expect(all_merchants_response[:data][0]).to have_key :id
      expect(all_merchants_response[:data][0]).to have_key :type
      expect(all_merchants_response[:data][0][:type]).to eq("merchant")
      expect(all_merchants_response[:data][0]).to have_key :attributes
      expect(all_merchants_response[:data][0][:attributes]).to have_key :name
      expect(all_merchants_response[:data][0][:attributes][:name]).to be_a String
      expect(all_merchants_response[:data][0][:attributes]).to_not have_key :created_at
      expect(all_merchants_response[:data][0][:attributes]).to_not have_key :updated_at
    end
  end

  describe "Get /api/v1/merchants/:id" do
    it "gets all data for 1 merchant" do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response).to be_a Hash
      expect(merchant_response[:data]).to be_a Hash
      expect(merchant_response[:data]).to have_key :id
      expect(merchant_response[:data]).to have_key :type
      expect(merchant_response[:data][:type]).to eq("merchant")
      expect(merchant_response[:data]).to have_key :attributes
      expect(merchant_response[:data][:attributes]).to have_key :name
      expect(merchant_response[:data][:attributes][:name]).to be_a String
      expect(merchant_response[:data][:attributes]).to_not have_key :created_at
      expect(merchant_response[:data][:attributes]).to_not have_key :updated_at
    end
  end

  describe "Get /api/v1/merchants/:id/items" do
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
      expect(merchant_items_response[:data][0][:type]).to eq("item")
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
  end
end
