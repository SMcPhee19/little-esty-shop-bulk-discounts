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
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    @bulk_discount.save
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  private

  def bulk_discount_params
    params.permit(:name, :percent, :quantity)
  end
end
