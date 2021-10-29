require 'rails_helper'

RSpec.describe 'Get /api/v1/revenue/merchants/:id' do
  it 'returns revenue for a single merchant' do
    merchant = create(:merchant)
    customer = create(:customer)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)
    item4 = create(:item, merchant: merchant)
    item5 = create(:item, merchant: merchant)
    item6 = create(:item, merchant: merchant)

    invoice1 = create(:invoice, customer: customer, merchant_id: merchant.id)
    invoice2 = create(:invoice, customer: customer, merchant_id: merchant.id)

    invoice_item1 = create(:invoice_item, item: item3, invoice: invoice1, quantity: 25, unit_price: 80.00)
    invoice_item2 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 10, unit_price: 5.00)
    invoice_item3 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 5, unit_price: 3.00)

    transaction1 = create(:transaction, invoice: invoice1, result: "success")
    transaction2 = create(:transaction, invoice: invoice2, result: "success")

    get "/api/v1/revenue/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_response).to be_a Hash
    expect(merchant_response[:data]).to be_a Hash
    expect(merchant_response[:data]).to have_key :id
    expect(merchant_response[:data]).to have_key :type
    expect(merchant_response[:data][:type]).to eq('merchant_revenue')
    expect(merchant_response[:data]).to have_key :attributes
    expect(merchant_response[:data][:attributes]).to have_key :revenue
    expect(merchant_response[:data][:attributes][:revenue]).to be_a Float
  end

  it 'renders a 404 if no merchant found for given id' do
    get "/api/v1/revenue/merchants/2"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end
end
