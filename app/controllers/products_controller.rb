class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  def detail
    product = Product.find(params[:id])
    respond_to do |format|
      format.json { render json: product }
    end
  end
  def save
    product = Product.new
    product.name = params[:name]
    product.price = params[:price]
    product.description = params[:description]
    product.quantity = params[:quantity]
    product.is_deleted = params[:is_deleted].present? ? params[:is_deleted] : 0
    product.save
  end
  def update_product_use_ajax
    product = Product.find(params[:id])
    product.update(
      name: params[:name],
      price: params[:price],
      quantity: params[:quantity],
      description: params[:description],
      is_deleted: params[:is_deleted]
    )
  end
end
