class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item

  validates :quantity, :unit_price, :status, :created_at, :updated_at, presence: true

  enum status: [:pending, :packaged, :shipped]
end
