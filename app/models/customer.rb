class Customer < ApplicationRecord
  self.primary_key = :id
  has_many :invoices
  has_many :items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :items

  def succesful_transactions
    self.transactions.where(result: 1).count
  end

  def self.top_5_successful_transactions
    select("customers.*, COUNT(transactions.id) AS successful_transactions_count")
      # Selecting all of the customers
      # Counting the transactions and aliasing it as successful_transactions_count
      .joins(:transactions)
      # Joining the customers to transactions
      .where(transactions: {result: :success})
      # Only selecting the transactions that were successful
      .group("customers.id")
      # Grouping the customers by their id
      .order("successful_transactions_count DESC")
      # Ordering the customers by the number of successful transactions they have
      .limit(5)
      # Only taking the top 5
  end
end