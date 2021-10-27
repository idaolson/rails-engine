class Api::V1::MerchantsController < ApplicationController
  def index
    per_page = 20
    page = 1
    merchants = Merchant.all.paginate(per_page, page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
  end
end
