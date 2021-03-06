class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant_items_index(params[:merchant_id])
    else
      per_page = params[:per_page].try(:to_i) || 20
      page = params[:page].try(:to_i) || 1
      items = Item.all.page_number(per_page, page)
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
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    else
      render json: { response: 'Not Found' }, status: :not_found
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: ItemSerializer.new(@item), status: :created
    else
      render json: { response: 'Bad Request' }, status: :bad_request
    end
  end

  def update
    if Item.exists?(params[:id]) && valid_merchant?
      @item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(@item)
    else
      render json: { response: 'Not Found' }, status: :not_found
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

  def find_all
    if valid_find_all?
      item = if params[:name]
               Item.find_by_name(params[:name])
             else
               Item.find_by_price(params[:min_price], params[:max_price])
             end
      render json: ItemSerializer.new(item)
    else
      render json: { response: 'Bad Request' }, status: :bad_request
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def valid_merchant?
    return false if item_params['merchant_id'] && !Merchant.exists?(item_params['merchant_id'].to_i)

    true
  end

  def valid_find_all?
    return true if (params[:name] && params[:name] != '') && !params[:min_price] && !params[:max_price]
    return true if !params[:name] && params[:min_price]
    return true if !params[:name] && params[:max_price]

    false
  end
end
