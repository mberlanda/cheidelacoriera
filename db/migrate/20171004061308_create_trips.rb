# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[5.0]
  def up
    create_table :trips do |t|
      t.integer :total_seats
      t.integer :available_seats
      t.integer :requested_seats
      t.integer :reserved_seats

      t.timestamps
    end
    add_reference :trips, :event, index: true, foreign_key: true
    add_reference :trips, :transport_mean, index: true, foreign_key: true
  end

  def down
    remove_reference :trips, :event
    remove_reference :trips, :transport_mean
    drop_table :trips
  end
end
