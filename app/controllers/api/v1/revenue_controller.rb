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
end
