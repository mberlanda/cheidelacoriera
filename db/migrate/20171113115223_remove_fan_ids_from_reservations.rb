# frozen_string_literal: true

class RemoveFanIdsFromReservations < ActiveRecord::Migration[5.0]
  def up
    remove_column :reservations, :fan_ids
  end

  def down
    add_column :reservations, :fan_ids, :integer, array: true, default: []
  end
end
