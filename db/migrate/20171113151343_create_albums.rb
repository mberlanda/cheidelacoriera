# frozen_string_literal: true

class CreateAlbums < ActiveRecord::Migration[5.0]
  def up
    create_table :albums do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
    add_reference :albums, :event, index: true, foreign_key: true
  end

  def down
    remove_reference :albums, :event
    drop_table :albums
  end
end
