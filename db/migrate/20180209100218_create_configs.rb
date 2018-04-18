class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.string :product_name
      t.integer :cost
      t.integer :count

      t.timestamps
    end
  end
end
