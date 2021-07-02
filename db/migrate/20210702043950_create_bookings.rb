class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :timeslot_id, null: false
      t.integer :user_id, null: false
      t.integer :state, default: 0, null: false
      t.json    :metadata, default: {}

      t.timestamps
    end

    add_index :bookings, :timeslot_id
    add_index :bookings, :user_id
    add_index :bookings, :state
  end
end
