class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :credits do |t|
      t.string :date
      t.string :name
      t.integer :cost
      t.integer :status

      t.timestamps
    end
  end
end
