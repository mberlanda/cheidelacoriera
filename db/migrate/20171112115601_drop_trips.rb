# frozen_string_literal: true

class DropTrips < ActiveRecord::Migration[5.0]
  def up
    remove_reference :reservations, :trip
    add_reference :reservations, :event, index: true, foreign_key: true

    remove_reference :trips, :event
    remove_reference :trips, :transport_mean
    drop_table :trips

    add_column :events, :bookable_from, :date
    add_column :events, :bookable_until, :date
    add_column :events, :requested_seats, :integer, default: 0
    add_column :events, :confirmed_seats, :integer, default: 0
  end

  def down
    remove_column :events, :bookable_from
    remove_column :events, :bookable_until
    remove_column :events, :requested_seats
    remove_column :events, :confirmed_seats

    create_table :trips do |t|
      t.integer :total_seats
      t.integer :available_seats
      t.integer :requested_seats
      t.integer :reserved_seats
      t.string :name
      t.date :bookable_from
      t.date :bookable_until

      t.timestamps
    end
    add_reference :trips, :event, index: true, foreign_key: true
    add_reference :trips, :transport_mean, index: true, foreign_key: true

    add_reference :reservations, :trip, index: true, foreign_key: true
    remove_reference :reservations, :event
  end
end
