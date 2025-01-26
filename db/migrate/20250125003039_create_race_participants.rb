class CreateRaceParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :race_participants do |t|
      t.references :race, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.integer :lane, null: false
      t.integer :place

      t.timestamps
    end

    add_index :race_participants, [:race_id, :lane], unique: true
    add_index :race_participants, [:race_id, :student_id], unique: true
  end
end
