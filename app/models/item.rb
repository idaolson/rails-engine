class Item < ApplicationRecord
  belongs_to :merchant
  # has_many :invoice_items
  # has_many :invoices, through: :invoice_items
  validates :name, :description, :unit_price, presence: true

  def self.find_by_name(query)
    where('name ILIKE ?', "%#{query}%")
      .order(name: :asc)
  end 
end
