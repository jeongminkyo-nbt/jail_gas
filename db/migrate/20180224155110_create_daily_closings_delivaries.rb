class CreateDailyClosingsDelivaries < ActiveRecord::Migration[5.0]
  def up
    create_table(:daily_closings_delivaries, id: false) do |t|
      t.references :daily_closings
      t.references :delivaries
    end

    add_index(:daily_closings_delivaries, [:daily_closings_id, :delivaries_id], :name => 'daily_closings_delivaries_index')

  end

  def down
    drop_table :daily_closings_delivaries
  end
end
