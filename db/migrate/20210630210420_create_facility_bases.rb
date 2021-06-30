class CreateFacilityBases < ActiveRecord::Migration[6.1]
  def change
    create_table :facility_bases do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.json :metadata, default: {}
      t.timestamps
    end

    add_index :facility_bases, :type
  end
end
