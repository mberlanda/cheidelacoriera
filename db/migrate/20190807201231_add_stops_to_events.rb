# frozen_string_literal: true

class AddStopsToEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :events, :stops, :string
  end

  def down
    remove_column :events, :stops
  end
end
