require 'rails_helper'

RSpec.describe "Get /api/v1/items" do
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
end
