class AddStatusToDelivaries < ActiveRecord::Migration[5.0]
  def change
    add_column :delivaries, :status, :boolean
  end
end
