class CreateBeacons < ActiveRecord::Migration[5.2]
  def change
    create_table :beacons do |t|
      t.string :title
      t.text :text
      t.integer :target
      t.integer :user_id

      t.timestamps
    end
  end
end
