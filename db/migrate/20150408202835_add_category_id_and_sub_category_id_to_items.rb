class AddCategoryIdAndSubCategoryIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :category_id, :integer
    add_column :items, :sub_category_id, :integer
    add_index :items, [:category_id, :sub_category_id]
    add_index :items, :sub_category_id
  end
end
