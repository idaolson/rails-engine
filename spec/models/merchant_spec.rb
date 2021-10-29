require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoice_items).through :items }
    it { should have_many(:invoices).through :invoice_items }
    it { should have_many(:transactions).through :invoices }
    it { should have_many(:customers).through :invoices }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'instance methods' do
    it "returns the name that most closely matches a full or partial search query alphabetically" do
      merchant1 = create(:merchant, name: "Ahsoka Tano")
      merchant2 = create(:merchant, name: "Anakin Skywalker")
      merchant3 = create(:merchant, name: "Kanan Jarrus")
      expect(Merchant.find_by_name('ana')).to eq(merchant2)
    end

    it "returns a number of merchants specified in params by the quantity of items sold" do
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

      expect(Merchant.most_items(2)).to eq([merchant2, merchant1])
    end

    it "returns the total revenue of a specific merchant by id" do
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

      expect(Merchant.total_revenue(merchant.id)).to be_a Merchant
      expect(Merchant.total_revenue(merchant.id).revenue).to eq(2065.0)
    end

    it "returns a specific number of merchants by ordered by most revenue" do
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

      expect(Merchant.most_revenue(2)).to eq([merchant2, merchant1])
    end
  end
end
