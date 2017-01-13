class CreateOrderCategories < ActiveRecord::Migration
  def change
    create_table :order_categories do |t|
      t.string :order_category_key, null: false         # カテゴリKey
      t.string :name, null: false                       # カテゴリ名

      t.timestamps null: false
    end
  end
end
