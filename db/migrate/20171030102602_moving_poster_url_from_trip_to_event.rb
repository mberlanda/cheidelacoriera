# frozen_string_literal: true

class MovingPosterUrlFromTripToEvent < ActiveRecord::Migration[5.0]
  def up
    remove_column :trips, :poster_url
    add_column :events, :poster_url, :string
  end

  def down
    remove_column :events, :poster_url
    add_column :trips, :poster_url, :string
  end
end
