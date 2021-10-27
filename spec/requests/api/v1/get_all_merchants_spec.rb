require 'rails_helper'

RSpec.describe "Get /api/v1/merchants" do
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
