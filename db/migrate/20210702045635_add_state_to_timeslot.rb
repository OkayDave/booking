class AddStateToTimeslot < ActiveRecord::Migration[6.1]
  def change
    add_column :timeslots, :state, :integer, default: 0
    add_index :timeslots, :state
  end
end
