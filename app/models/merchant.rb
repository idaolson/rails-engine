class Merchant < ApplicationRecord
  # has_many :items, dependent: :destroy
  # has_many :invoices, through: :items
  # has_many :invoice_items, through: :items

  validates :name, presence: true

end 
