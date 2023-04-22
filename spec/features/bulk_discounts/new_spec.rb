require 'rails_helper'

RSpec.describe 'merchant bulk discount new page' do
  before(:each) do
    @merchant = create(:merchant)
    @merchant1 = create(:merchant)

    @bulk1 = @merchant.bulk_discounts.create!(percent: 49, quantity: 40, name: '49% off 40 items')
    @bulk2 = @merchant.bulk_discounts.create!(percent: 43, quantity: 59, name: '43% off 59 items')
    @bulk3 = @merchant1.bulk_discounts.create!(percent: 21, quantity: 7, name: '21% off 7 items')

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

  it 'when in the bulk discount new page, I see a form to create a new bulk discount' do
    visit new_merchant_bulk_discount_path(@merchant)

    within '#new-merchant-bulk' do
      expect(page).to have_field('name')
      expect(page).to have_field('percent')
      expect(page).to have_field('quantity')
    end
  end

  it 'when in the bulk discount new page, when I fill out the form and click submit,
  I am taken to the bulk discount index page and the discount is there' do
    visit new_merchant_bulk_discount_path(@merchant)

    within '#new-merchant-bulk' do
      fill_in 'name', with: '16% off 14 items'
      fill_in 'percent', with: 16
      fill_in 'quantity', with: 14

      click_button 'Save'
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content('16% off 14 items')
  end
end