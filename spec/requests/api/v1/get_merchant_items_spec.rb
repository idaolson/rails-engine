require 'rails_helper'

RSpec.describe "Get /api/v1/merchants/:id/items" do
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
