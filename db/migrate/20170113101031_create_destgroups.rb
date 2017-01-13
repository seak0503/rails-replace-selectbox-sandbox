class CreateDestgroups < ActiveRecord::Migration
  def change
    create_table :destgroups do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :destgroups, :name, unique: true
  end
end
