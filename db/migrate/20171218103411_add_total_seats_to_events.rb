# frozen_string_literal: true

class AddTotalSeatsToEvents < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :total_seats, :integer, default: 0
  end

  def down
    remove_column :events, :total_seats
  end
end
