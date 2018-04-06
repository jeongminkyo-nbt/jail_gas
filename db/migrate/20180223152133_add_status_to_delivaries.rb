class AddStatusToDelivaries < ActiveRecord::Migration[5.0]
  def change
    add_column :delivaries, :status, :integer
  end
end
