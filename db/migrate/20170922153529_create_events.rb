# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.0]
  def up
    create_table :events do |t|
      t.date :date
      t.time :time
      t.string :season
      t.string :score
      t.text :notes
      t.references :home_team, foreign_key: { to_table: :teams }
      t.references :away_team, foreign_key: { to_table: :teams }

      t.timestamps
    end
    add_reference :events, :competition, index: true, foreign_key: true
  end

  def down
    remove_reference :events, :competition
    drop_table :events
  end
end
