require 'rails_helper'

RSpec.describe 'Get api/vi/revenue/items' do
   it 'returns items ranked by revenue' do
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

     get "/api/v1/revenue/items"

     expect(response).to be_successful

     items = JSON.parse(response.body, symbolize_names: true)

     expect(items).to be_a Hash
     expect(items[:data].count).to eq(3)
     expect(items[:data].first[:id].to_i).to eq(item3.id)
     expect(items[:data].first[:attributes][:revenue]).to eq(2000.0)
     expect(items[:data].second[:id].to_i).to eq(item1.id)
     expect(items[:data].second[:attributes][:revenue]).to eq(50.0)

     get "/api/v1/revenue/items?quantity=1"

     expect(response).to be_successful

     items = JSON.parse(response.body, symbolize_names: true)

     expect(items).to be_a Hash
     expect(items[:data].count).to eq(1)
   end

   it 'returns an error if quantity given is not greater than 0' do
     get "/api/v1/revenue/items?quantity=0"

     expect(response.status).to eq(400)
   end
end
