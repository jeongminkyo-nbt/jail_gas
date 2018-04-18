class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :date
      t.integer :gas_10kg
      t.integer :gas_20kg
      t.integer :gas_50kg
      t.integer :air
      t.integer :butane
      t.integer :argon
      t.integer :status

      t.timestamps
    end
  end
end
