class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.references :parent_service                      # 親分類への再帰リレーション
      t.string :service_key, null: false                # サービスKey
      t.string :name, null: false                       # サービス名

      t.timestamps null: false
    end

    add_index :services, :parent_service_id
    add_index :services, :service_key, unique: true
    add_index :services, :name, unique: true
    add_foreign_key :services, :services, column: 'parent_service_id'
  end
end
