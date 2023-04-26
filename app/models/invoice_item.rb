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

  def discount_applies?
    quantity_thresholds = item.merchant.bulk_discounts 
    # quantity_thresholds is set to the array of quanity values from the bulk_discounts table that came from .pluck
    # item.merchant.bulk_discounts is querying the
    # bulk_discounts table to find all the discounts associated with the merchant of the current item.
                              .pluck(:quantity)
    # .pluck is taking the quantity column from the bulk_discounts table and returning an array of the values
    quantity_thresholds.any? { |q| quantity >= q }
    # q's the value given to each element of the array of quantity values
    # .any? is checking to see if any of the values in the array are less than or equal to the quantity of the invoice item
    # returns a true or false value
  end

  def discount_applied
    bulk_discounts.where('? >= bulk_discounts.quantity', self.quantity)
                  # querying the bulk_discounts table to find any
                  # records where the quanity is less than or equal to the quantity of the invoice item
                  .order(percent: :desc).take 
                  # .take is taking the first record from the ordered results/
                  # does the same thing as .first
  end
end
