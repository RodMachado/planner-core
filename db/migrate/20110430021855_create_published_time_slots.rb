class CreatePublishedTimeSlots < ActiveRecord::Migration
  def self.up
    create_table :published_time_slots do |t|
      t.datetime :start
      t.datetime :end

      t.timestamps
      t.column :lock_version, :integer, { :default => 0 }
    end
  end

  def self.down
    drop_table :published_time_slots
  end
end
