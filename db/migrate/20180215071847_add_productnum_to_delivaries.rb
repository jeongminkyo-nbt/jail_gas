class AddProductnumToDelivaries < ActiveRecord::Migration[5.0]
  def change
    add_column :delivaries, :product_num, :integer
  end
end
