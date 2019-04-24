class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.text :bio
      t.string :cover_img
      t.string :profile_img
      t.string :venmo
      t.string :cash
      t.string :paypal
      t.string :zelle
      t.integer :user_id

      t.timestamps
    end
  end
end
