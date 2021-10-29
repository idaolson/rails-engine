class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, :description, :unit_price, presence: true

  def self.find_by_name(query)
    where('name ILIKE ?', "%#{query}%")
      .order(name: :asc)
  end

  def self.find_by_price(min_price = nil, max_price = nil)
    min_price = 0 if min_price.nil?
    max_price = Item.maximum(:unit_price) if max_price.nil?
    Item.where('unit_price >= ? AND unit_price <= ?', min_price, max_price)
  end

  def self.most_revenue(quantity = 10)
    joins(invoice_items: {invoice: :transactions})
    .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .where(transactions: { result: 'success' })
    .group("items.id")
    .order("revenue DESC")
    .limit(quantity)
  end
end
