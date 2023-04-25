# spec/features/admin/invoices/show_spec.rb
require 'rails_helper'

RSpec.describe 'admin_invoice_show3333', type: :feature do
  describe 'As an admin, when I visit the admin invoice show page' do
    before(:each) do
      @merchant = create(:merchant)

      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)
      @customer_4 = create(:customer)
      @customer_5 = create(:customer)
      @customer_6 = create(:customer)
      @customer_7 = create(:customer)

      @item_1 = create(:item, merchant_id: @merchant.id)
      @item_2 = create(:item, merchant_id: @merchant.id)
      @item_3 = create(:item, merchant_id: @merchant.id)
      @item_4 = create(:item, merchant_id: @merchant.id)
      @item_5 = create(:item, merchant_id: @merchant.id)
      @item_6 = create(:item, merchant_id: @merchant.id)
      @item_7 = create(:item, merchant_id: @merchant.id)

      static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
      static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
      static_time_3 = Time.zone.parse('2023-04-11 00:50:37')
      static_time_4 = Time.zone.parse('2023-04-10 00:50:37')
      @invoice_1 = create(:invoice, status: 'in progress', customer_id: @customer_1.id, created_at: static_time_1)
      @invoice_2 = create(:invoice, status: 'in progress', customer_id: @customer_2.id, created_at: static_time_2)
      @invoice_3 = create(:invoice, status: 'in progress', customer_id: @customer_3.id, created_at: static_time_3)
      @invoice_4 = create(:invoice, status: 'in progress', customer_id: @customer_4.id, created_at: static_time_4)
      @invoice_5 = create(:invoice, status: 'in progress', customer_id: @customer_5.id)
      @invoice_6 = create(:invoice, status: 'in progress', customer_id: @customer_6.id)
      @invoice_7 = create(:invoice, status: 'in progress', customer_id: @customer_7.id)

      create_list(:transaction, 3, result: 'success', invoice_id: @invoice_1.id)
      create_list(:transaction, 4, result: 'success', invoice_id: @invoice_2.id)
      create_list(:transaction, 5, result: 'success', invoice_id: @invoice_3.id)
      create_list(:transaction, 6, result: 'success', invoice_id: @invoice_4.id)
      create_list(:transaction, 7, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_5.id)
      create_list(:transaction, 2, result: 'success', invoice_id: @invoice_7.id)
      create_list(:transaction, 5, result: 'failed', invoice_id: @invoice_7.id)

      create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_3.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_4.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_5.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_4.id, item_id: @item_6.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_5.id, item_id: @item_7.id, status: 'shipped')

      visit admin_invoice_path(@invoice_1.id)
    end

    it 'has a header indicating that I am on the admin dashboard invoice show page' do
      expect(page).to have_content("Admin Dashboard - Invoice Show Page")
    end

    it 'displays the information related to the that invoice' do
      within("div#invoice_info") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content(@invoice_1.status)
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %e, %Y"))
        expect(page).to have_content(@invoice_1.customer.first_name)
        expect(page).to have_content(@invoice_1.customer.last_name)
        expect(@invoice_1.customer.first_name).to appear_before(@invoice_1.customer.last_name)
      end
    end

    it 'also displays item name, quantity, price, and status' do
      within("div#invoice_items") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.format_unit_price)
        expect(page).to have_content(@invoice_1.invoice_items.first.quantity)
        expect(page).to have_content(@invoice_1.invoice_items.first.status)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.format_unit_price)
        expect(page).to have_content(@invoice_1.invoice_items.last.quantity)
        expect(page).to have_content(@invoice_1.invoice_items.last.status)
      end
    end

    it 'displays the total revenue that will be generated from this invoice' do
      within("div#total_revenue") do
        expect(page).to have_content(@invoice_1.total_revenue)
      end
    end

    it 'displays the form for the invoice status' do
      within("#status_invoice") do
        expect(page).to have_select('invoice_status', selected: 'in progress')
        expect(page).to_not have_select('invoice_status', selected: 'completed')
        find("#invoice_status option[value='completed']").select_option
        click_button("Update Invoice")
        expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
        expect(page).to have_select('invoice_status', selected: 'completed')
      end

      within("div#invoice_info") do
        expect(page).to have_content("completed")
        expect(page).to_not have_content("in progress")
      end
    end
  end

  describe 'Admin Total Discounts' do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'another merchant')

      @item1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item3 = Item.create!(name: "hoodie", description: "very warm", unit_price: 20, merchant_id: @merchant2.id)

      @customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 9, unit_price: 1000, status: 2)
      @ii2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, quantity: 1, unit_price: 1000, status: 1)
      @ii3 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item3.id, quantity: 10, unit_price: 2000, status: 1)

      @bulk_discount1 = BulkDiscount.create!(name: '50% off 5', percent: 50, quantity: 5, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: '25% off 10', percent: 25, quantity: 10, merchant_id: @merchant2.id)
    end

    it 'when visiting the admin invoice show page, I see the total revenue from this invoice' do
      visit admin_invoice_path(@invoice1.id)
      within('div#total_revenue') do
        expect(page).to have_content(@invoice1.total_revenue)
      end
    end

    it 'when visiting the admin invoice show page, I see the total discounted revenue from this invoice' do
      visit admin_invoice_path(@invoice1.id)
      within('div#total_revenue') do
        expect(page).to have_content(@invoice1.total_rev_with_discount)
      end
    end
  end
end