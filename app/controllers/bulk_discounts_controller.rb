class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = @bulk_discount.merchant
  end

  def new
    # require 'pry'; binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    # @bulk_discount = BulkDiscount.new
    @bulk_discount = @merchant.bulk_discounts.new
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percent, :quantity)
  end
end
