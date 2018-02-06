class AddProductNameToCredits < ActiveRecord::Migration[5.0]
  def change
    add_column :credits, :product_name, :string, default: ''
  end
end
