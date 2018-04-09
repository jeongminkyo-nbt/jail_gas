class CreateDelivaries < ActiveRecord::Migration[5.0]
  def change
    create_table :delivaries do |t|
      t.string :date
      t.string :name
      t.string :deliver
      t.string :product_name
      t.integer :product_num
      t.integer :status
      t.integer :daily_closing_id
      t.timestamps
    end
  end
end
