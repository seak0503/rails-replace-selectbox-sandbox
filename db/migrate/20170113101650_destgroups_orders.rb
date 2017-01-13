class DestgroupsOrders < ActiveRecord::Migration
  def change
    create_table :destgroups_orders, id: false do |t|
      t.references :destgroup, index: true, null: false
      t.references :order, index: true, null: false
    end
  end
end
