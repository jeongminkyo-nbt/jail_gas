class CreateCompanyHosings < ActiveRecord::Migration[5.0]
  def change
    create_table :company_hosings do |t|
      t.integer :dong
      t.integer :ho
      t.string :name
      t.string :call
      t.integer :prev_month
      t.integer :current_month
      t.integer :usage
      t.integer :share
      t.integer :usage_money

      t.timestamps
    end
  end
end
