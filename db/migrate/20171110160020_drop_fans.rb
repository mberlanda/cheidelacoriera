# frozen_string_literal: true

class DropFans < ActiveRecord::Migration[5.0]
  def up
    remove_reference :fans, :user, index: true, foreign_key: true
    drop_table :fans
  end

  def down
    create_table :fans do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :fidelity_card_no

      t.timestamps null: false
    end
    add_reference :fans, :user, index: true, foreign_key: true
  end
end
