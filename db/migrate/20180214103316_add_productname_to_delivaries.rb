class AddProductnameToDelivaries < ActiveRecord::Migration[5.0]
  def change
    add_column :delivaries, :product_name, :string
  end
end
