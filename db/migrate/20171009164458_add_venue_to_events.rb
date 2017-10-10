# frozen_string_literal: true

class AddVenueToEvents < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :venue, :string
  end

  def down
    remove_column :events, :venue
  end
end
