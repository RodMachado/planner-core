class CreateEquipmentNeeds < ActiveRecord::Migration
  def self.up
    create_table :equipment_needs do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :equipment_needs
  end
end
