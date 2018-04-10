class CreateDailyClosingDoneDelivaries < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_closing_done_delivaries do |t|
      t.string :product_name
      t.integer :product_num
      t.integer :daily_closing_id

      t.timestamps
    end
  end
end
