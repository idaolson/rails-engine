class Api::V1::RevenueController < ApplicationController
  def most_revenue_items
    if !params[:quantity]
      items = Item.most_revenue
      render json: ItemRevenueSerializer.new(items)
    elsif params[:quantity].to_i > 0
      items = Item.most_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else
      render json: { error: 'Bad Request' }, status: :bad_request
    end
  end

  def total_revenue_merchant
    if Merchant.find_by(id: params[:id])
      merchant = Merchant.total_revenue(params[:id])
      render json: MerchantRevenueSerializer.new(merchant)
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def most_revenue_merchants
    quantity = params[:quantity].to_i
    if quantity > 0
      merchants = Merchant.most_revenue(quantity)
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render json: { error: 'Bad Request' }, status: :bad_request
    end
  end
end
