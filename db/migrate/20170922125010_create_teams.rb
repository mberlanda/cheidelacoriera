# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[5.0]
  def up
    create_table :teams do |t|
      t.string :name
      t.string :country
      t.string :url
      t.string :image_url
      t.text :description

      t.timestamps null: false
    end
  end

  def down
    drop_table :teams
  end
end
