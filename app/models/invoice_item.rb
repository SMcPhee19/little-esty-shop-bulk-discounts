class InvoiceItem < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :item
  has_many :merchants, through: :item

  enum status: ['pending', 'packaged', 'shipped']

  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end

  def items_name
    item.name
  end
end