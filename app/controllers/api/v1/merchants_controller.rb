class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = params[:per_page].to_i ||= 20
    page = params[:page].to_i ||= 1

    merchants = Merchant.all.page_number(per_page, page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
