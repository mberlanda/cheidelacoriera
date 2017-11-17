# frozen_string_literal: true

class UpdateSlugs < ActiveRecord::Migration[5.0]
  def change
    Competition.find_each(&:save)
    Event.find_each(&:save)
  end
end
