class CreateDailyClosings < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_closings do |t|
      t.string :date
      t.string :deliver
      t.integer :total_cost
      t.timestamps
    end
  end
end
