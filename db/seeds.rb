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

@merchant1 = Merchant.create!(name: 'Hair Care')
@merchant2 = Merchant.create!(name: 'another merchant')
@item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
@item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
@item_3 = Item.create!(name: "hoodie", description: "very warm", unit_price: 20, merchant_id: @merchant2.id)
@customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
@invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
@ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 1000, status: 2)
@ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 1000, status: 1)
@ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 10, unit_price: 2000, status: 1)
@bulk_discount1 = BulkDiscount.create!(name: '50% off 5', percent: 50, quantity: 5, merchant_id: @merchant1.id)
@bulk_discount2 = BulkDiscount.create!(name: '25% off 10', percent: 25, quantity: 10, merchant_id: @merchant2.id)