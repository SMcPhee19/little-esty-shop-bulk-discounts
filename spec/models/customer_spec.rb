require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:items).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe '#instance methods' do
    before(:each) do
      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)
      @customer_4 = create(:customer)
      @customer_5 = create(:customer)
      @customer_6 = create(:customer)
      @customer_7 = create(:customer)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, customer_id: @customer_2.id)
      @invoice_3 = create(:invoice, customer_id: @customer_3.id)
      @invoice_4 = create(:invoice, customer_id: @customer_4.id)
      @invoice_5 = create(:invoice, customer_id: @customer_5.id)
      @invoice_6 = create(:invoice, customer_id: @customer_6.id)
      @invoice_7 = create(:invoice, customer_id: @customer_7.id)

      create_list(:transaction, 3, result: 'success', invoice_id: @invoice_1.id)
      create_list(:transaction, 4, result: 'success', invoice_id: @invoice_2.id)
      create_list(:transaction, 5, result: 'success', invoice_id: @invoice_3.id)
      create_list(:transaction, 6, result: 'success', invoice_id: @invoice_4.id)
      create_list(:transaction, 7, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_5.id)
      create_list(:transaction, 2, result: 'success', invoice_id: @invoice_7.id)
      create_list(:transaction, 5, result: 'failed', invoice_id: @invoice_7.id)
    end
  
    describe '.top_5_successful_trans' do
      it 'can find the top 5 customers with highest number successful transactions' do
        expect(Customer.top_5_successful_transactions).to eq([@customer_5, @customer_4, @customer_3, @customer_2, @customer_1])
      end
    end

    describe 'succesful_transactions' do
      let!(:merchant) { create(:merchant) }
  
      let!(:item_1) { create(:item, merchant_id: merchant.id) }
      let!(:item_2) { create(:item, merchant_id: merchant.id) }
      let!(:item_3) { create(:item, merchant_id: merchant.id) }
      let!(:item_4) { create(:item, merchant_id: merchant.id) }
      let!(:item_5) { create(:item, merchant_id: merchant.id) }
      let!(:item_6) { create(:item, merchant_id: merchant.id) }
    
      let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
      let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
      let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
      let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
      let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
      let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }
    
      let!(:invoice_1) { create(:invoice, customer_id: customer_1.id) }
      let!(:invoice_2) { create(:invoice, customer_id: customer_2.id) }
      let!(:invoice_3) { create(:invoice, customer_id: customer_3.id) }
      let!(:invoice_4) { create(:invoice, customer_id: customer_4.id) }
      let!(:invoice_5) { create(:invoice, customer_id: customer_5.id) }
      let!(:invoice_6) { create(:invoice, customer_id: customer_6.id) }
      
      let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id) }
      let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id) }
      let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id) }
      let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id) }
      let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id) }
      let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id) }
    
      let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
      let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
      let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
      let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
      let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
      let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
      let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
      let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }

      it 'retreives succesful transactions count from a customer' do
        expect(customer_1.transactions.count).to eq(15)
        expect(customer_1.succesful_transactions).to eq(10)
        expect(customer_2.succesful_transactions).to eq(5)
        expect(customer_3.succesful_transactions).to eq(7)
        expect(customer_4.succesful_transactions).to eq(3)
      end
    end 
  end
end