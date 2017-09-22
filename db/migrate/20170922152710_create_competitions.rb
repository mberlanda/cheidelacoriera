# frozen_string_literal: true

class CreateCompetitions < ActiveRecord::Migration[5.0]
  def up
    create_table :competitions do |t|
      t.string :name, unique: true
      t.timestamps
    end
  end

  def down
    drop_table :competitions
  end
end
