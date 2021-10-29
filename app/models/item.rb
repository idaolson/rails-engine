class Item < ApplicationRecord
  belongs_to :merchant
  # has_many :invoice_items
  # has_many :invoices, through: :invoice_items
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
end
