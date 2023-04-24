class Invoice < ApplicationRecord
  self.primary_key = :id
  validates :status, presence: true
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ['cancelled', 'in progress', 'completed']

  def self.invoice_items_not_shipped
    select('invoices.*').joins(:invoice_items).where(invoice_items: { status: ['pending', 'packaged'] })
  end

  def format_time_stamp
    created_at.strftime('%A, %B %e, %Y')
  end

  def customer_full_name
    "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.sum('(quantity * unit_price )/ 100.0').round(2).to_s
  end

  def total_discounts
    invoice_items.joins(merchants: :bulk_discounts)
                 .where('invoice_items.quantity >= bulk_discounts.quantity')
                 .select('invoice_items.*,  MAX(bulk_discounts.percent) as discount')
                 .group(:id)
                 .sum { |invoice_item| invoice_item.quantity * invoice_item.unit_price * invoice_item.discount / 10_000.0 }
  end

  def total_rev_with_discount
    total = total_revenue.to_i - total_discounts
    total.round(2).to_s
  end
end