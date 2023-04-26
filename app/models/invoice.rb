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
    # selecting all of the invoices
    # joining the them on the invoice_items table
    # where the status of the invoice_item is either pending or packaged
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
                 # Joining the invoice_items table to the merchants table
                 # and to the bulk_discounts table
                 .where('invoice_items.quantity >= bulk_discounts.quantity')
                 # Filters the invoice_items to only include
                 # the ones that have met the quantity threshold for a bulk_discount
                 .select('invoice_items.*,  MAX(bulk_discounts.percent) as discount')
                 # Selects all of the invoice_items
                 # Also selects the maximum discount and alias it as discount
                 .group(:id)
                 # Groups the invoice_items by their id
                 # This makes sure that the calculation is done to each invoice_item
                 .sum { |invoice_item| invoice_item.quantity * invoice_item.unit_price * invoice_item.discount / 10_000.0 }
                 # Caclulate the total cost of each invoice_item
                 # By multiplying the quantity of the ii by the unit_price of said ii and the discount the ii qualifies for
                 # Then dividing by 10_000 to get the correct decimal
                 # (since my discounts are stored as integers, not floats, that is a REALLY big number)
                 # Then summing all of the invoice_items together to get the total discount for the invoice
  end

  def total_rev_with_discount
    total = total_revenue.to_i - total_discounts
    total.round(2).to_s
  end
end