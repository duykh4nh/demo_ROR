class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer "product_id"
      t.text "product_name"
      t.text "customer_id"
      t.text "product_name"
      t.text "product_name"
      t.timestamps
    end
  end
end
