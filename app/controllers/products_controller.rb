class ProductsController < ApplicationController
  def index
    @products = Product.all
  end
  def new
    @products = Product.new
  end
  def edit
    @product = Product.find(params[:id])
  end
  def save
    if params[:id].present?
      return update
    end
    product = Product.new
    product.name = params[:name]
    product.price = params[:price]
    product.description = params[:description]
    product.quantity = params[:quantity]
    product.is_deleted = 0
    product.save
    redirect_to(index_path)
  end
  def update
    @product = Product.find_by(id: params[:id])
    form_params = params.require(:product).permit(:name, :price, :description, :quantity, :is_deleted)
    @product.update(form_params) ? redirect_to(index_path) : render(:update)
  end
  def update_product_use_ajax
    product = Product.find(params[:id])
    updated_name = params[:name]
    updated_price = params[:price]
    updated_quantity = params[:quantity]
    updated_description = params[:description]

    product.update(
      name: updated_name,
      price: updated_price,
      quantity: updated_quantity,
      description: updated_description
    )

    render json: { message: 'Successfully' }
  end

  def update_is_deleted_product_use_ajax
    product = Product.find(params[:id])
    product.update(
      is_deleted: params[:is_deleted]
    )
    render json: { message: 'Successfully' }
  end
end
