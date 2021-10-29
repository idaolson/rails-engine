require 'rails_helper'

RSpec.describe 'Get api/vi/revenue/merchants' do
  it 'returns merchants ranked their revenue' do
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

    invoice_item1 = create(:invoice_item, item: item3, invoice: invoice1, quantity: 25, unit_price: 80.00)
    invoice_item2 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 10, unit_price: 5.00)
    invoice_item3 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 5, unit_price: 3.00)

    transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
    transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")

    get '/api/v1/revenue/merchants?quantity=2'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)
    expect(merchants[:data].first[:id].to_i).to eq(merchant2.id)
    expect(merchants[:data].first[:attributes][:revenue]).to eq(2000.0)
    expect(merchants[:data].second[:id].to_i).to eq(merchant1.id)
    expect(merchants[:data].second[:attributes][:revenue]).to eq(65.0)
  end

  it 'returns 400 error if the quantity param is less than 1' do
    get '/api/v1/revenue/merchants?quantity=0'

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'returns 400 error if no quantity param specified' do
    get '/api/v1/revenue/merchants'

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end
end
