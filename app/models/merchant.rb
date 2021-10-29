class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  # has_many :invoices, through: :items
  # has_many :invoice_items, through: :items

  validates :name, presence: true

  def self.find_by_name(query)
    Merchant.where('name ILIKE ?', "%#{query}%")
            .order(name: :asc)
            .first
  end
end
