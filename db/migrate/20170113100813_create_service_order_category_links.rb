class CreateServiceOrderCategoryLinks < ActiveRecord::Migration
  def change
    create_table :service_order_category_links do |t|
      t.references :service, null: false
      t.references :order_category, null: false
      t.integer  :display_order, null: false

      t.timestamps null: false
    end

    add_index :service_order_category_links, [ :service_id, :order_category_id, :display_order ], unique: true,
      name: 'index_service_order_category_links_on_service_category_display'
    add_foreign_key :service_order_category_links, :services
    add_foreign_key :service_order_category_links, :order_categories

  end
end
