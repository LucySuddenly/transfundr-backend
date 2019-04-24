class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :beacon_id
      t.integer :amount
      t.integer :points
      t.boolean :confirmed

      t.timestamps
    end
  end
end
