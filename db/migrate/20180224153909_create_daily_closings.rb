class CreateDailyClosings < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_closings do |t|
      t.string :date
      t.timestamps
    end
  end
end
