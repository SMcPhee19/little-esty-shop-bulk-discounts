class Merchant::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @total_discount = @invoice.total_rev_with_discount
  end
end