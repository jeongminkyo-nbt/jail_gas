class AddProductnumToCredits < ActiveRecord::Migration[5.0]
  def change
    add_column :credits, :product_num, :integer
  end
end
