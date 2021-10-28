class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant_items_index(params[:merchant_id])
    else
      per_page = 20
      page = 1
      items = Item.all.paginate(per_page, page)
      render json: ItemSerializer.new(items)
    end
  end

  def merchant_items_index(merchant_id)
    if Merchant.exists?(merchant_id)
      items = Item.where(merchant_id: merchant_id)
      render json: ItemSerializer.new(items)
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: ItemSerializer.new(@item), status: :created
    else
      render json: { response: 'Bad Request' }, status: :bad_request
    end
  end

  def destroy
    if Item.exists?(params[:id])
      Item.delete(params[:id])
      render json: { response: 'No Content' }, status: :no_content
    else
      render json: { response: 'Not Found' }, status: :not_found
    end
  end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
