class Item < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :description, presence: true
  validates :description, length: { minimum: 6 }
  validates :unit_price, presence: true
  validates :status, presence: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  enum status: ['enabled', 'disabled']

  def item_invoice_id_for_merchant
    invoice_items.first.invoice_id
  end

  def invoice_formatted_date
    invoice_items.first.invoice.created_at.strftime("%A, %B %e, %Y")
  end

  def unit_price=(val)
    write_attribute :unit_price, val.to_s.gsub(/\D/, '').to_i
  end

  def format_unit_price
    (unit_price / 100.00).round(2).to_s
  end
  
  def best_selling_date
    invoice = Item.joins(invoices: :transactions)
    # joins the items table to the invoices table to the transactions table
    .where('transactions.result = ? and invoice_items.item_id = ?', "1", self.id)
    # Only takes successful transactions and the invoice_items that belong to the item
    .select("invoices.*, SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue")
    # selects all of the invoices
    # sums the total of the invoice_items unit price and mulitplies it by the quantity
    # aliases it as total_revenue
    .group("invoices.id")
    # group the invoices by their id
    .order(total_revenue: :desc)
    # orders the invoices by their total_revenue highest to lowest
    .limit(1)
    # only takes the top result
    invoice.first.created_at.strftime("%A, %B %e, %Y")
    # formats the date of the invoice
  end
end