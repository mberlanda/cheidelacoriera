# frozen_string_literal: true

class AddDatesRangesToTrip < ActiveRecord::Migration[5.0]
  def up
    add_column :trips, :bookable_from, :date
    add_column :trips, :bookable_until, :date
    add_column :trips, :poster_url, :string
    add_column :trips, :name, :string
  end

  def down
    remove_column :trips, :bookable_from
    remove_column :trips, :bookable_until
    remove_column :trips, :poster_url
    remove_column :trips, :name
  end
end
