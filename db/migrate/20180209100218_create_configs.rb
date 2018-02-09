class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.integer :gas_10kg
      t.integer :gas_20kg
      t.integer :gas_50kg
      t.integer :air
      t.integer :butane
      t.integer :argon

      t.timestamps
    end
  end
end
