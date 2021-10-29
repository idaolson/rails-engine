class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params[:per_page].try(:to_i) || 20
    page = params[:page].try(:to_i) || 1
    merchants = Merchant.all.page_number(per_page, page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    if params[:item_id] && Item.exists?(params[:item_id])
      merchant = Item.find(params[:item_id]).merchant
      render json: MerchantSerializer.new(merchant)
    elsif params[:id] && Merchant.exists?(params[:id])
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end
end
