require 'rails_helper'

RSpec.describe 'Merchant Dashboard/Show Page' do
  before(:each) do
    @merchant = create(:merchant)
    @merchant1 = create(:merchant)

    @bulk1 = create(:bulk_discount, merchant_id: @merchant.id)
    @bulk2 = create(:bulk_discount, merchant_id: @merchant.id)
    @bulk3 = create(:bulk_discount, merchant_id: @merchant1.id)

    @item1 = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)
    @item3 = create(:item, merchant_id: @merchant.id)
    @item4 = create(:item, merchant_id: @merchant.id)
    @item5 = create(:item, merchant_id: @merchant.id)
    @item6 = create(:item, merchant_id: @merchant.id)
    @item7 = create(:item, merchant_id: @merchant.id)
    @item8 = create(:item, merchant_id: @merchant.id)
    @item9 = create(:item, merchant_id: @merchant1.id)

    @customer1 = create(:customer, first_name: 'Branden', last_name: 'Smith')
    @customer2 = create(:customer, first_name: 'Reilly', last_name: 'Robertson')
    @customer3 = create(:customer, first_name: 'Grace', last_name: 'Chavez')
    @customer4 = create(:customer, first_name: 'Logan', last_name: 'Nguyen')
    @customer5 = create(:customer, first_name: 'Brandon', last_name: 'Popular')
    @customer6 = create(:customer, first_name: 'Caroline', last_name: 'Rasmussen')

    @static_time1 = Time.zone.parse('2023-04-13 00:50:37')
    @static_time2 = Time.zone.parse('2023-04-12 00:50:37')

    @invoice1 = create(:invoice, customer_id: @customer1.id)
    @invoice2 = create(:invoice, customer_id: @customer2.id)
    @invoice3 = create(:invoice, customer_id: @customer3.id)
    @invoice4 = create(:invoice, customer_id: @customer4.id, created_at: @static_time1)
    @invoice5 = create(:invoice, customer_id: @customer5.id, created_at: @static_time2)
    @invoice6 = create(:invoice, customer_id: @customer6.id)
    @invoice7 = create(:invoice, customer_id: @customer6.id)

    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id, status: 2)
    @invoice_item2 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice2.id, status: 2)
    @invoice_item3 = create(:invoice_item, item_id: @item3.id, invoice_id: @invoice3.id, status: 2)
    @invoice_item4 = create(:invoice_item, item_id: @item4.id, invoice_id: @invoice4.id, status: 0)
    @invoice_item5 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice5.id, status: 0)
    @invoice_item6 = create(:invoice_item, item_id: @item6.id, invoice_id: @invoice6.id, status: 1)
    @invoice_item7 = create(:invoice_item, item_id: @item9.id, invoice_id: @invoice7.id, status: 1)

    @inv_1_transaction_s = create_list(:transaction, 10, result: 1, invoice_id: @invoice1.id)
    @inv_1_transaction_f = create_list(:transaction, 5, result: 0, invoice_id: @invoice1.id)
    @inv_2_transaction_s = create_list(:transaction, 5, result: 1, invoice_id: @invoice2.id)
    @inv_3_transaction_s = create_list(:transaction, 7, result: 1, invoice_id: @invoice3.id)
    @inv_4_transaction_s = create_list(:transaction, 3, result: 1, invoice_id: @invoice4.id)
    @inv_4_transaction_f = create_list(:transaction, 20, result: 0, invoice_id: @invoice4.id)
    @inv_5_transaction_s = create_list(:transaction, 11, result: 1, invoice_id: @invoice5.id)
    @inv_6_transaction_s = create_list(:transaction, 8, result: 1, invoice_id: @invoice6.id)
  end

  describe 'displays Merchants and their most recent attributes' do
    it 'should display the name of the merchant' do
      visit "/merchants/#{@merchant.id}/dashboard"

      expect(page).to have_content(@merchant.name)
    end
  end

  describe 'Top 5 Customers Column' do
    it 'should display the names of the top 5 customers by successful transactions in descending order' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#top_5_customers') do
        expect(@customer5.first_name).to appear_before(@customer1.first_name)
        expect(@customer1.first_name).to appear_before(@customer6.first_name)
        expect(@customer6.first_name).to appear_before(@customer3.first_name)
        expect(@customer3.first_name).to appear_before(@customer2.first_name)
        expect(@customer5.last_name).to appear_before(@customer1.last_name)
        expect(@customer1.last_name).to appear_before(@customer6.last_name)
        expect(@customer6.last_name).to appear_before(@customer3.last_name)
        expect(@customer3.last_name).to appear_before(@customer2.last_name)

        expect(@customer5.first_name).to appear_before(@customer5.last_name)
        expect(@customer1.first_name).to appear_before(@customer1.last_name)
        expect(@customer6.first_name).to appear_before(@customer6.last_name)
        expect(@customer3.first_name).to appear_before(@customer3.last_name)
        expect(@customer2.first_name).to appear_before(@customer2.last_name)

        expect(page).to_not have_content(@customer4.first_name)
        expect(page).to_not have_content(@customer4.last_name)
      end
    end

    it 'should display, next to the names, the number of successful transations of each top 5 customer' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#top_5_customers') do
        expect(page).to have_content(@inv_5_transaction_s.count)
        expect(page).to have_content(@inv_1_transaction_s.count)
        expect(page).to have_content(@inv_6_transaction_s.count)
        expect(page).to have_content(@inv_3_transaction_s.count)
        expect(page).to have_content(@inv_2_transaction_s.count)

        expect(@customer5.last_name).to appear_before('11')
        expect(@customer1.last_name).to appear_before('10')
        expect(@customer6.last_name).to appear_before('8')
        expect(@customer3.last_name).to appear_before('7')

        expect(page).to_not have_content(@inv_4_transaction_s.count)
      end
    end
  end

  describe 'displays links to merchant sub indexes' do
    it 'should display a link to merchant item index' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#item_index') do
        expect(page).to have_link('My Items')
      end
    end

    it 'link to merchant item index reroutes to /merchants/merchant_id/items' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#item_index') do
        click_link "My Items"

        expect(current_path).to eq(merchant_items_path(@merchant))
      end
    end

    it 'should display a link to merchant invoices index' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#invoice_index') do
        expect(page).to have_link('My Invoices')
      end
    end

    it 'link to merchant invoice index reroutes to /merchants/merchant_id/invoices' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within('#invoice_index') do
        click_link 'My Invoices'

        expect(current_path).to eq(merchant_invoices_path(@merchant))
      end
    end
  end

  describe 'items ready to ship' do 
    it 'should display a list of name for unshipped ordered items' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within '#shippable_items' do
        expect(page).to have_content('Items Ready to Ship')

        expect(page).to have_content(@item4.name)
        expect(page).to have_content(@item5.name)
        expect(page).to have_content(@item6.name)

        expect(page).to_not have_content(@item1.name)
        expect(page).to_not have_content(@item2.name)
        expect(page).to_not have_content(@item3.name)
        expect(page).to_not have_content(@item7.name)
        expect(page).to_not have_content(@item8.name)
        expect(page).to_not have_content(@item9.name)
      end
    end

    it 'should display the ID of the item to the right of item name' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within "#shippable_items" do
        expect(page).to have_content(@invoice4.id)
        expect(page).to have_content(@invoice5.id)
        expect(page).to have_content(@invoice6.id)

        expect(page).to_not have_content(@invoice1.id)
        expect(page).to_not have_content(@invoice2.id)
        expect(page).to_not have_content(@invoice3.id)
        expect(page).to_not have_content(@invoice7.id)

        # expect(invoice_4.id).to appear_before(invoice_5.id)
        # expect(invoice_5.id).to appear_before(invoice_6.id)
      end
    end

    it 'each ID is a link that routes to the merchants invoice show page' do
      visit "/merchants/#{@merchant.id}/dashboard"

      within '#shippable_items' do
        expect(page).to have_content(@invoice4.id)
        expect(page).to have_content(@invoice5.id)
        expect(page).to have_content(@invoice6.id)

        expect(page).to have_link(@invoice4.id.to_s)
        expect(page).to have_link(@invoice5.id.to_s)
        expect(page).to have_link(@invoice6.id.to_s)

        click_link(@invoice4.id.to_s)

        expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice4))

        visit "/merchants/#{@merchant.id}/dashboard"

        click_link(@invoice5.id.to_s)

        expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice5))

        visit "/merchants/#{@merchant.id}/dashboard"

        click_link(@invoice6.id.to_s)

        expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice6))
      end
    end7890

    it 'displays invoice creation formatted date like "Monday, July 18, 2019"' do
      visit "/merchants/#{@merchant.id}/dashboard"
      expect(page).to have_content(@item4.invoice_formatted_date)
      expect(page).to have_content(@item5.invoice_formatted_date)
      expect(page).to have_content(@item6.invoice_formatted_date)

      expect(page).to have_content('Thursday, April 13, 2023')
      expect(page).to have_content('Wednesday, April 12, 2023')
    end

    it 'orders the items by invoice creation date from oldest to newest' do
      visit "/merchants/#{@merchant.id}/dashboard"

      expect(@item5.invoice_formatted_date).to appear_before(@item4.invoice_formatted_date)
      expect('Wednesday, April 12, 2023').to appear_before('Thursday, April 13, 2023')
    end
  end

  describe 'bulk discounts' do
    it 'shows a link to all of a merchantss bulk discounts' do
      visit merchant_bulk_discount_path(@merchant)

      expect(page).to have_link('My Bulk Discounts')
    end
  end
end
