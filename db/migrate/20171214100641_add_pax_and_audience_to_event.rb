# frozen_string_literal: true

class AddPaxAndAudienceToEvent < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :audience, :string, default: :everyone
    add_column :events, :pax, :integer, default: 10
    add_column :events, :rejected_seats, :integer, default: 0
  end

  def down
    remove_column :events, :pax
    remove_column :events, :audience
    remove_column :events, :rejected_seats
  end
end
