class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :credits do |t|
      t.string :date
      t.string :name
      t.integer :cost
      t.integer :status
      t.string :product_name, default: ''
      t.integer :product_num
      t.integer :daily_closing_id
      t.timestamps
    end
  end
end
