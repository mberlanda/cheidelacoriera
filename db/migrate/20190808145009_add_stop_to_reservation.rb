# frozen_string_literal: true

class AddStopToReservation < ActiveRecord::Migration[5.2]
  def up
    add_column :reservations, :stop, :string
  end

  def down
    remove_column :reservations, :stop
  end
end
