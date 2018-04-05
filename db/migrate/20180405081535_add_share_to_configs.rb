class AddShareToConfigs < ActiveRecord::Migration[5.0]
  def change
    add_column :configs, :share, :integer, default: 0
    add_column :configs, :per_money, :integer, default: 0
  end
end
