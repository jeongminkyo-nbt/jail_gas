class AddUserRefToCredits < ActiveRecord::Migration[5.0]
  def change
    add_reference :credits, :user, foreign_key: true
  end
end
