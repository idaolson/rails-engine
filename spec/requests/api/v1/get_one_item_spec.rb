require 'rails_helper'

RSpec.describe "Get /api/v1/items/:id" do
  it "gets all data for 1 merchant" do
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
