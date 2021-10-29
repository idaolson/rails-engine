class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :credit_card_number, :result, presence: true

  enum result: [:failed, :success]
end
