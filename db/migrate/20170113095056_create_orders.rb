class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :order_category
      t.text :contract_number, null: false

      t.timestamps null: false
    end

    add_index :orders, :order_category_id
    add_foreign_key :orders, :order_categories
  end
end
