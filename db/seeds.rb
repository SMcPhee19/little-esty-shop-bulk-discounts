# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all
BulkDiscount.destroy_all

# @bulk1 = BulkDiscount.create!(percent: 33, quantity: 4, merchant_id: 1)
# @bulk2 = BulkDiscount.create!(percent: 75, quantity: 61, merchant_id: 1)
# @bulk3 = BulkDiscount.create!(percent: 43, quantity: 94, merchant_id: 2)
# @bulk4 = BulkDiscount.create!(percent: 30, quantity: 9, merchant_id: 2)