Rails.application.routes.draw do
  # get "/product/:id", to: "products#edit", as: 'products'
  # put "/product/:id", to: "products#save", as: 'products_update'
  # get "/product", to: "products#new", as: 'product_new'
  # put "/update_is_deleted_product_ajax/:id", to: "products#update_is_deleted_product_use_ajax", as: 'products_update_is_deleted_ajax'
  # post "/product_save_ajax", to: "products#save_ajax", as: 'product_save_ajax'

  get "/", to: "products#index", as: 'index'
  get "/product_detail", to: "products#detail", as: 'product_detail'
  post "/product", to: "products#save", as: 'product_save'
  put "/update_product_ajax", to: "products#update_product_use_ajax", as: 'products_update_ajax'
end
