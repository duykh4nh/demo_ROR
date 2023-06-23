class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    unless table_exists? :products
      create_table :products do |t|
        t.string "name"
        t.integer "price"
        t.integer "quantity"
        t.text "description"
        t.boolean "is_deleted"
        t.timestamps
      end
    end
  end
end