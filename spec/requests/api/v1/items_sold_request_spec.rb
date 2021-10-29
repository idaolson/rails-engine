require 'rails_helper'

RSpec.describe 'Get api/vi/merchants/most_items' do
  it 'returns merchants ranked by most items sold and the quantity sold' do
    merchant1 = create(:merchant, name: "Chibi")
    merchant2 = create(:merchant, name: "Bianca")
    merchant3 = create(:merchant, name: "Cassio")

    customer1 = create(:customer)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant2.id)
    item4 = create(:item, merchant_id: merchant2.id)
    item5 = create(:item, merchant_id: merchant3.id)
    item6 = create(:item, merchant_id: merchant3.id)

    invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id)
    invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant2.id)

    invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10)
    invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, quantity: 5)
    invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id, quantity: 90)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get '/api/v1/merchants/most_items?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(2)
    expect(merchants[:data].first[:id].to_i).to eq(merchant2.id)
    expect(merchants[:data].first[:attributes][:count]).to eq(90)
    expect(merchants[:data].second[:id].to_i).to eq(merchant1.id)
    expect(merchants[:data].second[:attributes][:count]).to eq(15)
  end

  it 'returns 400 error if the quantity param is less than 1' do
    get '/api/v1/merchants/most_items?quantity=0'

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end
end
