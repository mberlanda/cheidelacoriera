# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.0]
  def up
    create_table :posts do |t|
      t.string :title, null: false
      t.string :image_url
      t.text :content, null: false
      t.date :date
      t.string :slug

      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
