# frozen_string_literal: true

class AddTransportMeanToEvents < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :transport_mean, :string
    add_column :events, :available_seats, :integer, default: 0
  end

  def down
    remove_column :events, :available_seats
    remove_column :events, :transport_mean, :string
  end
end
