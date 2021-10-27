require 'rails_helper'

RSpec.describe "Get /api/v1/merchants/:id" do
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
