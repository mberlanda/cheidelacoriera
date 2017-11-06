# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[5.0]
  def up
    create_table :reservations do |t|
      t.integer :total_seats
      t.string :fan_names, array: true, default: []
      t.integer :fan_ids, array: true, default: []
      t.text :notes
      t.string :status
      t.string :phone_number

      t.timestamps
    end

    add_reference :reservations, :trip, index: true, foreign_key: true
    add_reference :reservations, :user, index: true, foreign_key: true
  end

  def down
    remove_reference :reservations, :trip
    remove_reference :reservations, :user
    drop_table :reservations
  end
end
