# frozen_string_literal: true

class AddSlugToEvents < ActiveRecord::Migration[5.0]
  def up
    add_column :events, :custom_name, :string, unique: true
    add_column :events, :slug, :string, unique: true
  end

  def down
    remove_column :events, :custom_name
    remove_column :events, :slug
  end
end
