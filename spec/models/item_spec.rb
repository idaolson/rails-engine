require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'instance methods' do
    it "finds by name or a fragment of a name and returns alphabetical array" do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant, name: "Slappy")
      item2 = create(:item, merchant: merchant, name: "Happy")
      item3 = create(:item, merchant: merchant, name: "Mo")

      expect(Item.find_by_name("ppy")).to eq([item2, item1])
    end

    it "finds items within min and max price params" do
      merchant = create(:merchant)
      item1 = create(:item, merchant: merchant, unit_price: 110.00)
      item2 = create(:item, merchant: merchant, unit_price: 50.01)
      item3 = create(:item, merchant: merchant, unit_price: 10.20)

      expect(Item.find_by_price(20.00, 100.00)).to eq([item2])
    end

    it "returns a given quantity of items sorted from highest revenue descending" do
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

      expect(Item.most_revenue(2)).to eq([item3, item1])
    end
  end
end
