class CreateEquipmentAssignments < ActiveRecord::Migration
  def self.up
    create_table :equipment_assignments do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :equipment_assignments
  end
end
