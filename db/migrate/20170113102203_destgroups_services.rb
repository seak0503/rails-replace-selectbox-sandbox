class DestgroupsServices < ActiveRecord::Migration
  def change
    create_table :destgroups_services, id: false do |t|
      t.references :service, index: true, null: false
      t.references :destgroup, index: true, null: false

      t.timestamps
    end
    add_index :destgroups_services, [ :service_id, :destgroup_id ], unique: true
    add_foreign_key :destgroups_services, :services
    add_foreign_key :destgroups_services, :destgroups
  end
end
