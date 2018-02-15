class CreateDelivaries < ActiveRecord::Migration[5.0]
  def change
    create_table :delivaries do |t|
      t.string :date
      t.string :name
      t.string :deliver

      t.timestamps
    end
  end
end
