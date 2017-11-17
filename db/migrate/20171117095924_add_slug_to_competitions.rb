# frozen_string_literal: true

class AddSlugToCompetitions < ActiveRecord::Migration[5.0]
  def up
    add_column :competitions, :slug, :string, unique: true
  end

  def down
    remove_column :competitions, :slug
  end
end
