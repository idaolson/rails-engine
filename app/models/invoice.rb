class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  validates :status, :customer_id, presence: true

  enum status: { :cancelled => 0, 'in progress' => 1, :completed => 2 }
end
