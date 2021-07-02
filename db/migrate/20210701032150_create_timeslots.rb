class CreateTimeslots < ActiveRecord::Migration[6.1]
  def change
    create_table :timeslots do |t|
      t.datetime :slot_time, null: false
      t.integer :facility_id, null: false

      t.timestamps
    end

    add_index :timeslots, %i[facility_id slot_time], unique: true, name: 'index_timeslot_facility_slot_time'
  end
end
