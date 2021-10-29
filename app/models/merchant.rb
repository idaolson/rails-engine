class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def self.find_by_name(query)
    where('name ILIKE ?', "%#{query}%")
      .order(name: :asc)
      .first
  end

  def self.most_items(quantity = 5)
    joins(items: { invoice_items: { invoice: :transactions } })
      .select('merchants.*, SUM(invoice_items.quantity) AS count')
      .where('transactions.result = ?', 'success')
      .group('merchants.id')
      .order('count desc')
      .limit(quantity)
  end

  def self.total_revenue(merchant_id)
    joins(items: {invoice_items: {invoice: :transactions}})
      .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .where("transactions.result = ? AND merchants.id = ?", "success", merchant_id)
      .group("merchants.id")
      .first
  end
end
